require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Author can delete link', js: true do
    log_in(author)
    visit question_path(question)

    within '.question-links' do
      expect(page).to have_link 'Search engine', href: 'https://yandex.ru'
      expect(page).to have_link 'Delete'

      click_on 'Delete'

      expect(page).to_not have_link 'Search engine', href: 'https://yandex.ru'
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Not author can not delete link', js: true do
    log_in(user)
    visit question_path(question)

    within '.question-links' do
      expect(page).to have_link 'Search engine', href: 'https://yandex.ru'
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Guest can not delete link', js: true do
    visit question_path(question)

    within '.question-links' do
      expect(page).to have_link 'Search engine', href: 'https://yandex.ru'
      expect(page).to_not have_link 'Delete'
    end
  end
end