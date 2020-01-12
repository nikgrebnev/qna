require 'rails_helper'

feature 'User can sign up', %q{
  Unauthenticated user can sign up
} do

  context 'as unregistered user' do
    background do
      visit root_path
      click_on 'Register'
    end

    context 'with corrected values' do
      background do
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: '12345678'
        fill_in 'Password confirmation', with: '12345678'
        click_on 'Sign up'
      end

      scenario 'User can register' do
        expect(page).to have_content 'You have signed up successfully.'
      end

      scenario 'Duplicate registration' do
        click_on 'Log out'
        visit new_user_registration_path

        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: '123456789'
        fill_in 'Password confirmation', with: '123456789'
        click_on 'Sign up'

        expect(page).to have_content 'Email has already been taken'
      end
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

  context 'as logged in user' do
    given(:user) { create(:user) }

    scenario 'User can not register' do
      log_in(user)
      visit new_user_registration_path

      expect(page).to have_content 'You are already signed in'
    end
  end
end