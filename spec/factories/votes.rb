FactoryBot.define do
  factory :vote do
   value { -1 }
   association :votable, factory: :question
   association :user, factory: :user
  end
end
