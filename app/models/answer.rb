class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope { order(best: :desc, created_at: :asc) }

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def make_best!
    transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
