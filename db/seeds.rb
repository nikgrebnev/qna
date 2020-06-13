# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# user = User.new(
#     :email                 => "nikolaygrebnev@yandex.ru",
#     :password              => "password123",
#     :password_confirmation => "password123",
# )
# user.skip_confirmation!
# user.type = "Admin"
# user.save!

user = User.create!(
    :email                 => "user1@test.com",
    :password              => "password123",
    :password_confirmation => "password123"
)
# user.skip_confirmation!
# user.save!

(1..10).each do |i|
  puts "question #{i}"
  question = Question.create(title: "Question #{i}", body: "Question #{i} body", user: user)
  (1..50).each do |t|
    comment = question.comments.create(body: "Question comment #{t} / #{i}", user: user)
  end
  (1..200).each do |t|
    answer = question.answers.create(body: "Question answer #{t} / #{i}", user: user)
    (1..50).each do |q|
      answer.comments.create(body: "Question #{t} / answer #{t} / comment #{q}", user: user)
    end
  end
end
