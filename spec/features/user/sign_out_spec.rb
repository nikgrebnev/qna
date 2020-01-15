require 'rails_helper'

feature 'User can sign out', %q{
  Authenticated user can sign out
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign out' do
    log_in(user)

    expect(page).to have_link 'Log out'

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    expect(page).to_not have_link 'Log out'
  end
end