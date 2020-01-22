require 'rails_helper'

feature 'best answer', %q{
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 10, question: question, user: user) }

  scenario 'author can choose best answer', js: true do
    log_in(author)
    visit question_path(question)

    expect(page).to have_link 'Make best answer'
    click_on 'Make best answer' , :match => :first
    expect(page).to have_content 'Best Answer'
  end

  scenario 'not author can not choose best answer', js: true do
    log_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Make best answer'
  end
end
