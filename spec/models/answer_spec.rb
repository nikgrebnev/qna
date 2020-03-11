require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_should_behave_like "links"
  it_should_behave_like "comments"
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :counter }

  describe 'uniqueness best check' do

    context 'validation 1'  do
      subject { FactoryBot.create(:answer) }
      before { allow_any_instance_of(Answer).to receive(:best?).and_return(true) }
      it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    end

    context 'validation 2'  do
      subject { FactoryBot.create(:answer) }
      before { subject.best = true }
      it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    end
  end

  describe 'uniqueness best check - 1' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user, best: true) }

    it 'check create second best answer' do
      expect do
        create(:answer, question: question, user: user, best: true)
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Best has already been taken')
    end

    context 'check create second best answer from another question' do
      let(:user) { create(:user) }
      let(:question2) { create(:question) }
      let!(:answer2) { create(:answer, question: question2, user: user, best: true) }

      it 'check count of best answers' do
        expect(Answer.where(best: true).count).to eq 2
      end
    end
  end

  it_should_behave_like 'Model Vote' do
    let(:question_author) { create(:user) }
    let(:answer_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }
    let(:answer) { create(:answer, question: question, user: answer_author) }
    let(:resource) { answer }
  end

  describe 'attaches' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'have many attached files' do
      expect(question.answers.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

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
      expect(best_answer).to be_best
      expect(answers.last).to_not be_best
    end

    it 'set another' do
      answers.each { |answer| answer.make_best! }
      answers.each { |answer| answer.reload }
      expect(answers.first).to_not be_best
      expect(answers.last).to be_best
    end
  end
end
