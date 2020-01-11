require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Sign in'
  end

  context 'as registered user' do
    background do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    scenario 'tries to sign in' do
      expect(page).to have_content 'Signed in successfully.'
  #    save_and_open_page
    end

    scenario 'logged in tries to sign in' do
      expect(page).to_not have_selector(:link_or_button, 'Sign in')

      visit new_user_session_path
      expect(page).to have_content  'You are already signed in.'
    end
  end


  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong_user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end