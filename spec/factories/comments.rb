FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n} body"
    end
    user
    association :commentable, factory: :question

    trait :invalid do
      body { nil }
    end
  end
end
