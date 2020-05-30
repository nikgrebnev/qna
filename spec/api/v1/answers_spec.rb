require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:method) { :get }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, :with_file, user: user, question: question) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_request) { get api_path, params: { access_token: access_token.token }, headers: headers }
      let(:answer_response) { json['answer'] }

      before { answer_request }

      it_behaves_like 'Status OK'

      it_behaves_like 'Check public fields' do
        let(:fields) { %w[id body best user_id created_at updated_at] }
        let(:reference) { answer }
        let(:resource_response) { answer_response }
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }
        let(:comment) { comments.last }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it_behaves_like 'Check public fields' do
          let(:fields) { %w[id body user_id created_at updated_at] }
          let(:reference) { comment }
          let(:resource_response) { comment_response }
        end
      end

      describe 'attached files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'] }

        it 'returns list of files' do
          expect(file_response.size).to eq 1
        end

        it 'returns url of file' do
          expect(file_response.first['url']).to eq rails_blob_path(file, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 3
        end

        it_behaves_like 'Check public fields' do
          let(:fields) { %w[id name url created_at updated_at] }
          let(:reference) { link }
          let(:resource_response) { link_response }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers, create new answer' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:answer_params) { { body: 'Body test' } }
      let(:answer_request) {
        post api_path, params: {
            access_token: access_token.token,
            answer: answer_params
        },
             headers: headers
      }
      let(:answer_response) { json['answer'] }

      it_behaves_like 'Status OK' do
        let(:request) { answer_request }
      end

      it 'saves answer in database' do
        expect { answer_request }.to change(Answer, :count).by(1)
      end

      it_behaves_like 'Check public fields' do
        let(:request) { answer_request }
        let(:fields) { %w[body user_id created_at updated_at] }
        let(:reference) { Answer.first }
        let(:resource_response) { answer_response }
      end

      it 'check question' do
        answer_request
        expect(answer_response['question']['id']).to eq question.id.as_json
      end

    end
  end

  describe 'PATCH /api/v1/questions/:question_id/answers/:id, update answer' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question)}
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:answer_params) { { body: 'New Body test'} }
      let(:answer_request) {
        patch api_path, params: {
            access_token: access_token.token,
            answer: answer_params
        },
             headers: headers
      }
      let(:answer_response) { json['answer'] }

      it_behaves_like 'Status OK' do
        let(:request) { answer_request }
      end

      it 'not changed answers count in database' do
        expect { answer_request }.to change(Answer, :count).by(0)
      end

      it_behaves_like 'Check public fields' do
        let(:request) { answer_request }
        let(:fields) { %w[body user_id created_at updated_at] }
        let(:reference) { Answer.first }
        let(:resource_response) { answer_response }
      end

      it 'check question' do
        answer_request
        expect(answer_response['question']['id']).to eq question.id.as_json
      end

      it 'saves answer in database with new params' do
        answer_request
        expect(Answer.last.body).to eq answer_params[:body]
      end
    end
  end


  describe 'DELETE /api/v1/questions/:question_id/answers/:id, delete answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_request) { delete api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK' do
        let(:request) { answer_request }
      end

      it 'changed count answers in database' do
        expect { answer_request }.to change(Answer, :count).by(-1)
      end
    end
  end
end
