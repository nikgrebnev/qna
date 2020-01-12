require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: author) }



  describe 'POST #create' do
    let(:params) { { question_id: question, answer: attributes_for(:answer) } }
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save the answer' do
        expect { post :create, params: params }.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: params
        expect(response).to render_template :new
      end
    end
  end

end
