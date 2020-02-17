class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: { in: [-1, 1] }, presence: true
#  validates :user_id, uniqueness: { scope: :votable_id, message: 'can vote once!' }
  validates_uniqueness_of :user_id, scope: [:votable_id, :votable_type], message: 'can vote once!'
end
