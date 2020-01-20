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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'author' do
      before { login(author) }

      context 'with valid attributes' do

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do

        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'other user, with valid attributes' do
      before { login(user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        # такая проверка нормальная? Или лучше по-другому?
        expect(answer.body).to_not eq 'new body'
      end
    end
  end
end
