require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let!(:question) { create(:question, :with_file, user: question_author) }
  let!(:answer) { create(:answer, :with_file, question: question, user: answer_author) }

  describe 'DELETE #destroy' do
    context 'Question as author' do
      before { login(question_author) }

      it 'deletes attach in question' do
        expect { delete :destroy, params: { id: question.files.first, format: :js } }.to change(question.files, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question.files.first, format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'Question as other user' do
      before { login(user) }

      it 'deletes the attach' do
        expect { delete :destroy, params: { id: question.files.first, format: :js } }.to_not change(question.files, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question.files.first, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'Answer as author' do
      before { login(answer_author) }

      it 'deletes attach in answer' do
        expect { delete :destroy, params: { id: answer.files.first, format: :js } }.to change(answer.files, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer.files.first, format: :js }
        expect(response).to redirect_to answer.question
      end
    end

    context 'Answer as other user' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer.files.first, format: :js } }.to_not change(answer.files, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer.files.first, format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
