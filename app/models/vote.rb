class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, inclusion: { in: [-1, 1] }, presence: true
  validates :votable_id, uniqueness: { scope: %i[votable_type user_id], message: 'can vote once!' }
end
