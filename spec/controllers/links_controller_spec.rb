require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let!(:question) { create(:question, user: question_author) }
  let!(:answer) { create(:answer, question: question, user: answer_author) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    context 'Question as author' do
      before { login(question_author) }

      it 'deletes link in question' do
        expect { delete :destroy, params: { id: question.links.first, format: :js } }.to change(question.links, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question.links.first, format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'Question as other user' do
      before { login(user) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: question.links.first, format: :js } }.to_not change(question.links, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question.links.first, format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'Answer as author' do
      before { login(answer_author) }

      it 'deletes link in answer' do
        expect { delete :destroy, params: { id: answer.links.first, format: :js } }.to change(answer.links, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer.links.first, format: :js }
        expect(response).to redirect_to answer.question
      end
    end

    context 'Answer as other user' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer.links.first, format: :js } }.to_not change(answer.links, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer.links.first, format: :js }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
