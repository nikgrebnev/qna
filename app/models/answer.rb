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

  after_create_commit :notify_users

  def make_best!
    transaction do
      self.question.answers.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def notify_users
    NewAnswerDigestJob.perform_later(self)
  end

end
