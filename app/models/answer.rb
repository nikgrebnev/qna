class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

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
