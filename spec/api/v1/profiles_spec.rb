require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status OK'

      it_behaves_like 'Check public fields' do
        let(:fields) { %w[id email created_at updated_at] }
        let(:reference) { me }
        let(:resource_response) { json['user'] }
      end

      it_behaves_like 'Check not public fields' do
        let(:fields) { %w[password encrypted_password] }
        let(:resource_response) { json['user'] }
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

      it_behaves_like 'Status OK'

      it 'returns list of users' do
        expect(json['users'].size).to eq 5
      end

      it 'does not include current user' do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id.as_json
        end
      end

      it_behaves_like 'Check public fields' do
        let(:fields) { %w[id email created_at updated_at] }
        let(:reference) { users.first }
        let(:resource_response) { user_response }
      end

      it_behaves_like 'Check not public fields' do
        let(:fields) { %w[password encrypted_password] }
        let(:resource_response) { user_response }
      end

      it 'Check type=User' do
        expect(user_response['type']).to eq 'User'
      end
    end
  end
end