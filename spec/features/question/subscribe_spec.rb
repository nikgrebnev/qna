require 'rails_helper'

feature 'User can subscribe question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }


  describe 'Authenticated author of question', js: true do
    before do
      log_in author
      visit question_path(question)
    end

    scenario 'subscribed to new answers' do
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribed from new answers' do
      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Authenticated user can subscribe to question', js: true do
    before do
      log_in user
      visit question_path(question)
    end

    scenario 'subscribed to new answers' do
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribed from new answers' do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Guest' do
    scenario 'can\'t subscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
