FactoryBot.define do
  factory :vote do
   value { -1 }
   association :votable, factory: :question
   association :user
  end
end
