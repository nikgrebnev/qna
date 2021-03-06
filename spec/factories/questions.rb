FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Question title #{n}"
    end

    user

    sequence :body do |n|
      "Question body #{n} body body"
    end

    trait :with_file do
      after :create do |question|
        file = fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
        question.files.attach(file)
      end
    end

    trait :with_reward do
      reward { build(:reward) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
