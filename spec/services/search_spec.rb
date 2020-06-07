require 'sphinx_helper'

RSpec.describe SearchService do
  context 'Base search tests' do
    let(:query) { 'test query' }

    it 'Run sphinx search with all models' do
      expect(ThinkingSphinx).to receive(:search).with(query)
      SearchService.new({query: query, model: 'all'}).call
    end

    it 'Run sphinx search with question models' do
      expect(ThinkingSphinx).to receive(:search).with(query, class: ['question'])
      SearchService.new({query: query, model: 'question'}).call
    end

    it 'Not run sphinx search with incorrect model' do
      expect(ThinkingSphinx).to_not receive(:search).with(query)
      SearchService.new({query: query, model: 'link'}).call
    end
  end

  context 'Base search tests' do
    let(:query) { 'test' }
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:comments) { create_list :comment, 3, body: 'test comment', user: user, commentable: question }

    it 'check comments search' do
      allow(ThinkingSphinx).to receive(:search).and_return(comments)
      result = SearchService.new({query: query, model: 'all'}).call
      expect(result).to eq comments
    end
  end
end