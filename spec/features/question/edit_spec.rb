require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:test_link) { 'https://ya.ru' }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'author edits his question', js: true do
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
        within '.question-edit' do
          expect(page).to_not have_selector 'textarea'
        end
      end
    end

    scenario 'author edits his question and add attaches', js: true do
      log_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb", "#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'author edits his question and add links', js: true do
      log_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        click_on 'Add link'
        fill_in 'Link name', with: 'Yandex'
        fill_in 'Url', with: test_link

        click_on 'Save'
        expect(page).to have_link 'Yandex', href: test_link
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
