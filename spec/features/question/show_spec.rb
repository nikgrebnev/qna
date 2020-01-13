require 'rails_helper'

feature 'show question', %q{
} do

  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 10, question: question, user: author) }

  scenario 'show question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
