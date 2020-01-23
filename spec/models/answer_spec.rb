require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe 'default_scope' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 2, question: question, user: user) }

    it 'shows best answer first' do
      best_answer = answers.last
      best_answer.make_best!
      question.answers.reload
      expect(question.answers).to_not eq answers
      expect(question.answers.first).to eq best_answer
    end
  end

  describe 'test make_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 2, question: question, user: user) }

    it 'set best' do
      best_answer = answers.first
      best_answer.make_best!
      answers.each { |answer| answer.reload }
      expect(best_answer.best?).to be_truthy
      expect(answers.last.best?).to be_falsey
    end

    it 'set another' do
      answers.each { |answer| answer.make_best! }
      answers.each { |answer| answer.reload }
      expect(answers.first.best?).to be_falsey
      expect(answers.last.best?).to be_truthy
    end
  end
end
