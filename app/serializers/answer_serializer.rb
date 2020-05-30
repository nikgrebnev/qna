class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at, :best, :user_id, :files

  has_many :comments
  has_many :links

  belongs_to :question

  def files
    list = []
    object.files.each do |file|
      list << { name: file.filename.to_s,
                url: rails_blob_path(file, only_path: true) }
    end
    list
  end

end


