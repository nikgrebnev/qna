require 'rails_helper'

feature 'User can sign out', %q{
  Authenticated user can sign out
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign out' do
    log_in(user)

    expect(page).to have_selector(:link_or_button, 'Log out')

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
#    save_and_open_page
    expect(page).to_not have_selector(:link_or_button, 'Log out')
  end
end