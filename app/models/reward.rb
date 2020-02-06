class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :reward_file

  validates :name, :reward_file, presence: true
end
