require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }


  describe 'default_scope' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 10, question: question, user: user) }
    let(:best_answer) { create(:answer, question: question, user: user) }

    it 'shows best answer first' do
      best_answer.make_best
      question.answers.reload
      expect(question.answers.first).to eq best_answer
    end
  end
end
