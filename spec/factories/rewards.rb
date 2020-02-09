FactoryBot.define do
  factory :reward do
    name { "Test reward" }
    reward_file { fixture_file_upload("#{Rails.root}/app/assets/images/test1.jpg") }
    association :question, factory: :question

    trait :file2 do
      name { "Test 2 reward" }
      reward_file { fixture_file_upload("#{Rails.root}/app/assets/images/test2.jpg") }
    end

    trait :file3 do
      name { "Test 3 reward" }
      reward_file { fixture_file_upload("#{Rails.root}/app/assets/images/test3.jpg") }
    end
  end
end
