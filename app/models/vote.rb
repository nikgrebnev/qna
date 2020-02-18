class VoteUserValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id == record.votable&.user_id
      record.errors[:base] << "Author can not vote for his resource"
    end
  end
end

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: { in: [-1, 1] }, presence: true
  validates_uniqueness_of :votable_id, scope: [:votable_type, :user_id], message: 'can vote once!'
  validates_with VoteUserValidator
end
