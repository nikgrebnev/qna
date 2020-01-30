require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:author_question) { create(:user) }
  given!(:question) { create(:question, user: author_question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'author edits his answer', js: true do
      log_in author
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'author edits his answer and add attaches', js: true do
      log_in author
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb", "#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      log_in author
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
      end
    end

    scenario "tries to edit other user's question" do
      log_in user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
