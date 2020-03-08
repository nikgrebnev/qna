FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n} body"
    end
    user
    association :commentable, factory: :question
  end
end
