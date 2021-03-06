require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it_behaves_like 'voted' do
    let(:resource) { question }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: author) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(author) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(get :new, params: {}).to render_template :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(author) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(author) }
    let(:params) { { question: attributes_for(:question) } }

    context 'with valid attributes' do

      it 'saves a new question in the database' do
        expect { post :create, params: params }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: params
        expect(response).to redirect_to assigns(:question)
      end

      it 'check correct author user_id' do
        post :create, params: params
        expect(assigns(:question).user).to eq(author)
      end
    end

    context 'with invalid attributes' do

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context  'unlogged user' do
      before { sign_out(author) }

      it 'does not save question' do
        expect { post :create, params: params }.to_not change(Question, :count)
      end

      it 'redirect to sign in' do
        post :create, params: params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(author) }

    context 'with valid attributes' do

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not change question' do
        original_question = question
        question.reload

        expect(question.title).to eq original_question.title
        expect(question.body).to eq original_question.body
      end

      it 're-renders edit view' do
        expect(patch :update, params: params).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: author) }

    context 'As question author' do
      before { login(author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'As other user' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to root' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_path
      end
    end
  end
end
