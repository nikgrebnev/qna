require 'rails_helper'

feature 'reply question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'reply question from registered user' do
    log_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Test answer'
    click_on 'Reply'

    expect(page).to have_content 'Test answer'
  end

  scenario 'check invalid body' do
    log_in(user)
    visit question_path(question)

    click_on 'Reply'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'reply question from unregistered user' do
    visit question_path(question)
    expect(page).to_not have_button, 'Reply'
  end
end



