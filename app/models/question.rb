class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :reward
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, :counter,  presence: true

  after_create_commit :subscribe_user!

  private

  def subscribe_user!
    user.subscribe!(self)
  end
end
