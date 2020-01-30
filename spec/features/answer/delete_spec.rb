require 'rails_helper'

feature 'delete answer', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:author_question) { create(:user) }
  given(:question) { create(:question, user: author_question) }

  describe 'Without attachments' do
    given!(:answer) { create(:answer, question: question, user: author) }

    scenario 'delete from author', js: true do
      log_in(author)
      visit question_path(question)

      within('.answers') do
        expect(page).to have_link 'Delete'
        click_on 'Delete'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'check delete button from another user', js: true do
      log_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end

    scenario 'check delete button from unlogged user', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'With attachments' do
    given!(:answer) { create(:answer, :with_file, question: question, user: author) }

    scenario 'delete attaches from author' do
      log_in(author)
      visit question_path(question)

      within('.answer-attaches') do
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link('Delete')
        click_on 'Delete'
        expect(page).to_not have_link('Delete')
      end
    end

    scenario 'delete attaches from other user' do
      log_in(user)
      visit question_path(question)

      within('.answer-attaches') do
        expect(page).to_not have_link('Delete')
      end
    end
  end

end