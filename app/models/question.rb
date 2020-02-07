class Question < ApplicationRecord
  include Linkable

  has_many :answers, dependent: :destroy
  has_one :reward

  belongs_to :user

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  has_many_attached :files

  validates :title, :body, presence: true
end
