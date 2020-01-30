FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "Answer body #{n} body"
    end
    question { nil }

    trait :with_file do
      after :create do |answer|
        file = fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
        answer.files.attach(file)
      end
    end

    trait :invalid do
      body { nil }
    end
  end
end