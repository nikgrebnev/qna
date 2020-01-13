require 'rails_helper'

feature 'delete question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'delete from author' do
    log_in(author)
    visit question_path(question)

    expect(page).to have_link 'Delete'
    click_on 'Delete'

    expect(page).to have_content 'Deleted successfully'
    expect(page).to_not have_content question.title
  end

  scenario 'check delete button from another user' do
    log_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'check delete button from unlogged user' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end