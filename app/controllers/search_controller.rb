class SearchController < ApplicationController
  skip_authorization_check

  def index
    @result = SearchService.new(params_search).call
  end

  private

  def params_search
    params.permit(:query, :model)
  end
end
