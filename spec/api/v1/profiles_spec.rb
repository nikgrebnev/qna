require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => 'application/json',
                    "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end

      it 'Check type=User' do
        expect(json['user']['type']).to eq 'User'
      end
    end
  end


  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:user_response) { json['users'].first}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 5
      end

      it 'does not include current user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id.as_json
        end
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end

      it 'Check type=User' do
        expect(user_response['type']).to eq 'User'
      end
    end
  end
end