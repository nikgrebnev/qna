class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: -1..1, presence: true
  validates :user_id, uniqueness: { scope: :votable_id, message: 'can vote once!' }
end
