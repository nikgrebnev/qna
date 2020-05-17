require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :rewards }
  it { should have_many :votes }
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
end
