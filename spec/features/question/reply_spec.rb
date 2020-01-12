require 'rails_helper'

feature 'reply question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'reply question from refistered user' do
    log_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Test answer'
    click_on 'Reply'

    expect(page).to have_content 'Test answer'
#    save_and_open_page
  end

end