require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'author edits his answer', js: true do
      log_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      log_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end
    end

    scenario "tries to edit other user's question" do
      log_in user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
