require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it {should be_able_to :read, Question}
    it {should be_able_to :read, Answer}
    it {should be_able_to :read, Comment}
    it {should be_able_to :read, ActiveStorage::Attachment}
    it {should be_able_to :read, Link}

    it {should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

end