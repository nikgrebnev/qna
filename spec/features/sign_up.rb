require 'rails_helper'

feature 'User can sign up', %q{
  Unauthenticated user can sign up
} do

  background { visit new_user_registration_path }

  scenario 'User can register with corrected values' do
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end

  scenario 'User can not register with uncorrected password' do
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '123456789'
    click_on 'Sign up'

    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario 'User can not register with uncorrected email' do
    fill_in 'Email', with: 'usertesttest'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    #save_and_open_page
    expect(page).to have_content 'Email is invalid'
  end
end