require 'rails_helper'

feature 'reply question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    background do
      log_in(user)

      visit question_path(question)
    end

    scenario 'reply question from registered user', js: true do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'reply question with attached files', js: true do
      fill_in 'Answer', with: 'Test answer'

      attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb", "#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'check invalid body', js: true do
      click_on 'Reply'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'reply question from unregistered user' do
    visit question_path(question)
    expect(page).to_not have_button, 'Reply'
  end

  context "multiple sessions", :cable, js: true  do
    given(:not_author) { create(:user) }

    scenario "all users see new answer in real-time" do
      Capybara.using_session('author') do
        log_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('not author') do
        log_in(not_author)
        visit question_path(question)
      end

      Capybara.using_session('author') do
        fill_in 'Answer', with: 'Test answer'
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end

      Capybara.using_session('not author') do
        within '.answers' do
          expect(page).to have_content 'Test answer'
        end
      end
    end
  end
end



