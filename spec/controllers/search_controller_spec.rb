require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:params) { {query: 'test string', model: 'question'} }

    before do
      allow(ThinkingSphinx).to receive(:search).and_return([])
      allow(SearchService).to receive(:new).and_return(SearchService.new(params))
      get :index, params: params
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'returns status 200' do
      expect(response.status).to eq 200
    end
  end
end