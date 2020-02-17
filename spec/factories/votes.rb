FactoryBot.define do
  factory :vote do
    value { 1 }
    association :user, factory: :user
    association :votable, factory: :question
  end
end
