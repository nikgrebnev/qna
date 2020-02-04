require 'rails_helper'

feature 'User can delete links from answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:author_question) { create(:user) }
  given(:question) { create(:question, user: author_question) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Author can delete link', js: true do
    log_in(author)
    visit question_path(question)

    within '.answer-links' do
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

    within '.answer-links' do
      expect(page).to have_link 'Search engine', href: 'https://yandex.ru'
      expect(page).to_not have_link 'Delete'
    end
  end

end