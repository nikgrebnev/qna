FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "Question title #{n}"
    end

    sequence :body do |n|
      "Question body #{n} body body"
    end

    trait :with_file do
      files do
        fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
        fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
