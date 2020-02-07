require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to :question }

  it 'have one attached file' do
    expect(Reward.new.reward_file).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'check users reward' do
    let(:user) { create(:user) }
    let(:reward_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: reward_user) }
    let!(:reward) { create(:reward, question: question, user: nil) }

    it 'check set reward' do
      answer.make_best!
      expect(reward.user).to eq reward_user
      expect(reward_user.rewards.first).to eq reward
    end
  end
end
