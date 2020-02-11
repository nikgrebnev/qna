require 'rails_helper'

feature 'vote question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Authenticated user can vote to question of other user', js: true do
    log_in(user)

    visit question_path(question)

    within '.question-vote' do
      expect(page).to have_link 'Vote up'
      expect(page).to have_link 'Vote down'
      expect(page).to_not have_link 'Cancel vote'
      expect(page).to have_content 'Votes: 0'
      click_on 'Vote up'
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to have_link 'Cancel vote'
      expect(page).to have_content 'Votes: 1'
      click_on 'Cancel vote'
      expect(page).to have_link 'Vote up'
      expect(page).to have_link 'Vote down'
      expect(page).to_not have_link 'Cancel vote'
      expect(page).to have_content 'Votes: 0'
      click_on 'Vote down'
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to have_link 'Cancel vote'
      expect(page).to have_content 'Votes: -1'
    end
  end

  scenario 'Author can not vote to his question', js: true do
    log_in(author)

    visit question_path(question)

    within '.question-vote' do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to_not have_link 'Cancel vote'
      expect(page).to have_content 'Votes: 0'
    end
  end

  scenario 'Guest can not vote to a question', js: true do
    visit question_path(question)

    within '.question-vote' do
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote down'
      expect(page).to_not have_link 'Cancel vote'
      expect(page).to have_content 'Votes: 0'
    end
  end
end



