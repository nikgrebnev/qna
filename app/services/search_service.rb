class SearchService
  SEARCH_MODELS = %w[question answer comment user all]
  attr_reader :query, :scope

  def initialize(params)
    @query = ThinkingSphinx::Query.escape(params[:query])
    @scope = ThinkingSphinx::Query.escape(params[:model])
  end

  def call
    return [] unless SEARCH_MODELS.include?(@scope)

    return ThinkingSphinx.search(@query) if @scope == 'all'

    ThinkingSphinx.search(@query, class: [@scope])
  end
end
