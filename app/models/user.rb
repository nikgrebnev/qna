class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards
  has_many :votes

  def author?(object)
    id == object.user_id
  end
end
