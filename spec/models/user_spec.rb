require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :rewards }
  it { should have_many :votes }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  context 'check author' do
    it 'as author' do
      expect(author).to be_author(question)
    end

    it 'not author' do
      expect(user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123123123') }
    let(:service) { double('Service::FindForOauth') }

    it 'call Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'subscriptions' do
    let(:other_user) { create :user }
    let!(:subscription) { create :subscription, user: user, question: question }

    context '#subscribed_of?' do
      it 'subscribed to the question' do
        expect(user).to be_subscribed(question)
      end

      it 'unsubscribed of the question' do
        expect(other_user).to_not be_subscribed(question)
      end
    end

    context '#subscribe!' do
      it 'create new question' do
        expect { user.questions.create(attributes_for(:question)) }.to change(user.subscriptions, :count).by(1)
      end

      it 'subscribe to current question' do
        expect { other_user.subscribe!(question) }.to change(other_user.subscriptions, :count).by(1)
      end

      it 'can not create duplicate subscribe to the question' do
        expect do
          user.subscribe!(question)
        end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: User has already been taken')
      end
    end

    context '#unsubscribe!' do
      it 'unsubscribe user' do
        expect { user.unsubscribe!(question) }.to change(user.subscriptions, :count).by(-1)
      end

      it 'unsubscribe author' do
        expect { author.unsubscribe!(question) }.to change(author.subscriptions, :count).by(-1)
      end
    end
  end
end
