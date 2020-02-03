require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }


  scenario 'User adds link when asks answer', js: true do
    log_in(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Test answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Reply'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Test answer'
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end