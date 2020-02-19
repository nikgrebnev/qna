require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :rewards }
  it { should have_many :votes }

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
end
