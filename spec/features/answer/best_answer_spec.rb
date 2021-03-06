require 'rails_helper'

feature 'best answer', %q{
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, :with_reward,  user: author) }
  given!(:answers) { create_list(:answer, 10, question: question, user: user) }

  scenario 'author can choose best answer', js: true do
    log_in(author)
    visit question_path(question)

    expect(page).to_not have_css(".best-answer")
    expect(page).to have_link 'Make best answer'
    click_on 'Make best answer' , :match => :first
    expect(page).to have_content 'Best Answer'
    expect(page).to have_css(".best-answer")
  end

  scenario 'not author can not choose best answer', js: true do
    log_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Make best answer'
  end

  scenario 'guest can not choose best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Make best answer'
  end

  scenario 'best answer show in first position', js: true do
    log_in(author)
    visit question_path(question)

    within("#answer#{answers.last.id}") do
      click_on 'Make best answer'
      expect(page).to have_content 'Best Answer'
    end

    within('.answers') do
      first_answer = all('div').first
      expect(first_answer).to have_content('Best Answer')
    end
  end
end
