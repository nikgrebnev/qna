require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, :with_file, user: user) }

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'As author' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'As other user' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(question.answers, :count).by(0)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end


end
