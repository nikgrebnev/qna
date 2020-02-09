FactoryBot.define do
  factory :link do
    name { "Search engine" }
    url { "https://yandex.ru" }

    trait :gist_url do
      url { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
    end
  end
end
