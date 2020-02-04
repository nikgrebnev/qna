class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist?
    url.downcase.start_with?("https://api.github.com/gists/","https://gist.github.com/")
  end

  def gist_content
    gist_id = url.split("/")[-1]
    GistQuestionService.new().call(gist_id)
  end
end
