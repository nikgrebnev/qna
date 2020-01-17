require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }



  describe 'POST #create' do
    let(:answer) { create(:answer, question: question, user: author) }
    let(:params) { { question_id: question, answer: attributes_for(:answer), format: :js } }
    before { login(author) }

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to render_template :create
      end

      it 'check correct author user_id' do
        post :create, params: params
        expect(assigns(:answer).user).to eq(author)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not save the answer' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context  'unlogged user' do
      before { sign_out(author) }

      it 'does not save answer' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 'redirect to sign in' do
        post :create, params: params
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'As answer author' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'As other user' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(0)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end
  end
end
