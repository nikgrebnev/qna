require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end


  describe 'GET /api/v1/questions/:id' do
    let(:method) { :get }
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, user: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 4, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it 'returns 1 question' do
        expect(json.size).to eq 1
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'comments' do
        let(:comment_response) { question_response['comments'].first }
        let(:comment) { comments.last }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'attached files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'] }

        it 'returns list of files' do
          expect(file_response.size).to eq 1
        end

        it 'returns url of file' do
          expect(file_response.first['url']).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 4
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:method) { :get }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answers) { create_list(:answer, 6, question: question) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      describe 'answers list' do
        let(:answer) { answers.first }
        let(:answer_response) { json['answers'].first }

        it_behaves_like 'Status OK'

        it 'returns list of answers' do
          expect(json['answers'].size).to eq 6
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions, create new question' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question_params) { { title: 'Title test', body: 'Body test'} }
      let(:question_request) {
         post api_path, params: {
              access_token: access_token.token,
              question: question_params
            },
            headers: headers
      }
      let(:question_response) { json['question'] }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it 'saves question in database' do
        expect { question_request }.to change(Question, :count).by(1)
      end

      it_behaves_like 'Check public fields' do
        let(:request) { question_request }
        let(:fields) { %w[title body created_at updated_at] }
        let(:reference) { Question.first }
        let(:resource_response) { question_response }
      end

      it 'check user' do
        question_request
        expect(question_response['user']['id']).to eq assigns(:question).send('user_id').as_json
      end

    end
  end

  describe 'PATCH /api/v1/questions/:id, update question' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_params) { { title: 'New Title test', body: 'New Body test'} }
      let(:question_request) {
        patch api_path, params: {
            access_token: access_token.token,
            question: question_params
        },
             headers: headers
      }
      let(:question_response) { json['question'] }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it 'not changed count questions in database' do
        expect { question_request }.to change(Question, :count).by(0)
      end

      it_behaves_like 'Check public fields' do
        let(:request) { question_request }
        let(:fields) { %w[id title body created_at updated_at] }
        let(:reference) { Question.first }
        let(:resource_response) { question_response }
      end

      it 'saves question in database with new params' do
        question_request
        expect(Question.last.body).to eq question_params[:body]
        expect(Question.last.title).to eq question_params[:title]
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id, delete question' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_request) { delete api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK' do
        let(:request) { question_request }
      end

      it 'changed count questions in database' do
        expect { question_request }.to change(Question, :count).by(-1)
      end
    end
  end
end