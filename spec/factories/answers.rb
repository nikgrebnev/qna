FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "Answer body #{n} body"
    end
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end