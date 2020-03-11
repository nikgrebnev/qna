require 'rails_helper'

feature 'add comment to question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'comment question from registered user', js: true do
    log_in(user)

    visit question_path(question)

    within '.question-comments' do
      fill_in 'comment_body', with: 'Test comment'
      click_on 'Send comment'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test comment'
    end
  end

  scenario 'comment question from registered user with invalid parameters', js: true do
    log_in(user)

    visit question_path(question)

    within '.question-comments' do
      click_on 'Send comment'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'reply question from unregistered user' do
    visit question_path(question)
    expect(page).to_not have_button, 'Send comment'
  end

  context "multiple sessions", :cable, js: true  do
    given(:not_author) { create(:user) }

    scenario "all users see new comment to question in real-time" do
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
        fill_in 'comment_body', with: 'Test comment'
        click_on 'Send comment'

        expect(current_path).to eq question_path(question)
        within '.question-comments' do
          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('not author') do
        within '.question-comments' do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end



