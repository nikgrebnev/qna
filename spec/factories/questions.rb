FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Question title #{n}"
    end

    sequence :body do |n|
      "Question body #{n} body body"
    end

    trait :invalid do
      title { nil }
    end
  end
end
