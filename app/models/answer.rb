class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  default_scope { order(best: :desc, created_at: :asc) }

  validates :body, :counter, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def make_best!
    transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
