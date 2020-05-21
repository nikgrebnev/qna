require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question}
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment}
    it { should be_able_to :read, ActiveStorage::Attachment}
    it { should be_able_to :read, Link}
    it { should be_able_to :read, :all}

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question_user) { create(:question, user: user) }
    let(:question_other) { create(:question, user: other_user) }
    let(:answer_user) { create(:answer, question: question_user, user: user) }
    let(:answer_other) { create(:answer, question: question_other, user: other_user) }
    let(:comment_user) { create(:comment, commentable: question_user, user: user) }
    let(:comment_other) { create(:comment, commentable: question_user, user: other_user) }

    it { should be_able_to :read, :all}
    it { should_not be_able_to :manage, :all }

    context 'Questions' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question_user }
      it { should_not be_able_to :update, question_other }
      it { should be_able_to :destroy, question_user }
      it { should_not be_able_to :destroy, question_other }
      it { should_not be_able_to :voteup, question_user }
      it { should be_able_to :voteup, question_other }
      it { should_not be_able_to :votecancel, question_user }
      it { should be_able_to :votecancel, question_other }
      it { should_not be_able_to :votedown, question_user }
      it { should be_able_to :votedown, question_other }
    end

    context 'Answers' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer_user }
      it { should_not be_able_to :update, answer_other }
      it { should be_able_to :destroy, answer_user }
      it { should_not be_able_to :destroy, answer_other }
      it { should_not be_able_to :voteup, answer_user }
      it { should be_able_to :voteup, answer_other }
      it { should_not be_able_to :votecancel, answer_user }
      it { should be_able_to :votecancel, answer_other }
      it { should_not be_able_to :votedown, answer_user }
      it { should be_able_to :votedown, answer_other }
      it { should be_able_to :make_best, answer_user }
      it { should_not be_able_to :make_best, answer_other }
    end

    context 'Comments' do
      it { should be_able_to :create, Comment }
      it { should be_able_to :update, comment_user }
      it { should_not be_able_to :update, comment_other }
      it { should be_able_to :destroy, comment_user }
      it { should_not be_able_to :destroy, comment_other }
    end

    context 'Attachments' do
      let(:file) { create_file('spec/rails_helper.rb') }

      let(:attachment_user) do
        question_user.files.attach(file)
        question_user.files.last
      end

      let(:attachment_other) do
        question_other.files.attach(file)
        question_other.files.last
      end

      it { should be_able_to :destroy, attachment_user }
      it { should_not be_able_to :destroy, attachment_other }
    end

    context 'Links' do
      let(:link_user) { create(:link, linkable: question_user) }
      let(:link_other) { create(:link, linkable: question_other) }

      it { should be_able_to :destroy, link_user }
      it { should_not be_able_to :destroy, link_other }
    end
  end
end