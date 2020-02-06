FactoryBot.define do
  factory :reward do
    name { "Test reward" }
    reward_file { fixture_file_upload("#{Rails.root}/app/assets/images/test1.jpg") }
    association :question, factory: :question
  end
end
