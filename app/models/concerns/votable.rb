module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def vote(user,value)
    votes.create!(user: user, value: value) #if can_vote?(user)
  end

  def votes_rate
    self.votes.sum(:value)
  end

  def vote_cancel(user)
    votes.where(user: user).delete_all
  end

  def can_vote?(user)
    !user.author?(self) && !voted?(user)
  end

  def can_cancel?(user)
    !user.author?(self) && voted?(user)
  end

  private

  def voted?(user)
    user.votes.exists?(votable: self)
  end

  def current_vote(user)
    votes.find_by(user: user).value
  end
end