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
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      let(:answer_response) { json['answer'] }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields best' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }
        let(:comment) { comments.last }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
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

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end


    end
  end
end
