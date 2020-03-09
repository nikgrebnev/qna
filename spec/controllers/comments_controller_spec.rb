require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, :with_reward, user: user) }
  let(:answer) { create(:answer, question: question, user: author) }

  describe 'POST #create, question' do
    let(:params) { { question_id: question, comment: attributes_for(:comment), format: :js } }
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: params }.to change(question.comments, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to render_template :create
      end

      it 'check correct author user_id' do
        post :create, params: params
        expect(assigns(:comment).user).to eq(author)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { question_id: question, comment: attributes_for(:comment, :invalid), format: :js } }

      it 'does not save the comment' do
        expect { post :create, params: params }.to_not change(Comment, :count)
      end

      it 're-renders new view' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context  'unlogged user' do
      before { sign_out(author) }

      it 'does not save comment' do
        expect { post :create, params: params }.to_not change(Comment, :count)
      end

      it 'redirect to sign in' do
        post :create, params: params
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #create, answer' do
    let(:params) { { answer_id: answer, comment: attributes_for(:comment), format: :js } }
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: params }.to change(answer.comments, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to render_template :create
      end

      it 'check correct author user_id' do
        post :create, params: params
        expect(assigns(:comment).user).to eq(author)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { answer_id: answer, comment: attributes_for(:comment, :invalid), format: :js } }

      it 'does not save the comment' do
        expect { post :create, params: params }.to_not change(Comment, :count)
      end

      it 're-renders new view' do
        post :create, params: params
        expect(response).to render_template :create
      end
    end

    context  'unlogged user' do
      before { sign_out(author) }

      it 'does not save comment' do
        expect { post :create, params: params }.to_not change(Comment, :count)
      end

      it 'redirect to sign in' do
        post :create, params: params
        expect(response).to have_http_status(401)
      end
    end
  end

end
