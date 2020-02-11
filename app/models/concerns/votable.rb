module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def can_vote?
    !current_user.author?(self) && current_user.votes.find_by(votable: self).nil?
  end

  def can_cancel?
    !current_user.author?(self) && !current_user.votes.find_by(votable: self).nil?
  end
end