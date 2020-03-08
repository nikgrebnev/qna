require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }

  describe 'Authenticated user' do
    background do
      log_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test body'
      click_on 'Ask'

      expect(page).to have_content 'Successfully added'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'test body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test body'

      attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb", "#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end

  describe 'Add reward' do
    background do
      log_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test body'

      within '.reward' do
        fill_in 'Reward name', with: 'test reward'
        attach_file 'Image', "#{Rails.root}/app/assets/images/test1.jpg"
      end

      click_on 'Ask'
    end

    scenario 'Author ask a question with reward (name and file)' do
      expect(page).to have_content 'test reward'
      expect(page).to have_css("img[src*='test1.jpg']")
    end

    scenario 'Not author can not see reward' do
      log_out
      log_in(not_author)
      visit questions_path
      click_on 'Show'

      expect(page).to_not have_content 'test reward'
      expect(page).to_not have_css("img[src*='test1.jpg']")
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context "multiple sessions", :cable, js: true  do
    scenario "all users see new question in real-time" do
      Capybara.using_session('author') do
        log_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('not author') do
        log_in(not_author)
        visit questions_path
      end

      Capybara.using_session('author') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test body'
        click_on 'Ask'

        expect(page).to have_content 'Successfully added'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('not author') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end