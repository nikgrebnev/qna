require 'rails_helper'

feature 'User can sign via omniauth ', %q{
} do

  describe "access via GitHub" do

    it "user does not exists" do
      visit new_user_session_path
      expect(page).to have_content("Sign in with GitHub")
      mock_auth_hash_github
      click_link "Sign in with GitHub"
      expect(page).to have_content 'Log out'
    end

    it "user exists" do
      create(:user, email: 'test@test.com')
      visit new_user_session_path
      expect(page).to have_content("Sign in with GitHub")
      mock_auth_hash_github
      click_link "Sign in with GitHub"
      expect(page).to have_content 'Log out'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_content("Sign in with GitHub")
      click_link "Sign in with GitHub"
      expect(page).to_not have_content 'Log out'
      expect(page).to have_content('Could not authenticate')
    end
  end

  describe "access via Facebook" do

    it "user does not exists" do
      visit new_user_session_path
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_hash_facebook
      click_link "Sign in with Facebook"
      expect(page).to have_content 'Log out'
    end

    it "user exists" do
      create(:user, email: 'test@test.com')
      visit new_user_session_path
      expect(page).to have_content("Sign in with Facebook")
      mock_auth_hash_facebook
      click_link "Sign in with Facebook"
      expect(page).to have_content 'Log out'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_content("Sign in with Facebook")
      click_link "Sign in with Facebook"
      expect(page).to_not have_content 'Log out'
      expect(page).to have_content('Could not authenticate')
    end
  end

  describe "access via Vkontakte" do

    it "user does not exists" do
      visit new_user_session_path
      expect(page).to have_content("Sign in with Vkontakte")
      mock_auth_hash_vkontakte
      click_link "Sign in with Vkontakte"
      expect(page).to have_content 'Log out'
    end

    it "user exists" do
      create(:user, email: 'test@test.com')
      visit new_user_session_path
      expect(page).to have_content("Sign in with Vkontakte")
      mock_auth_hash_vkontakte
      click_link "Sign in with Vkontakte"
      expect(page).to have_content 'Log out'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_content("Sign in with Vkontakte")
      click_link "Sign in with Vkontakte"
      expect(page).to_not have_content 'Log out'
      expect(page).to have_content('Could not authenticate')
    end
  end

  describe "access via GoogleOauth2" do

    it "user does not exists" do
      visit new_user_session_path
      expect(page).to have_content("Sign in with GoogleOauth2")
      mock_auth_hash_google_oauth2
      click_link "Sign in with GoogleOauth2"
      expect(page).to have_content 'Log out'
    end

    it "user exists" do
      create(:user, email: 'test@test.com')
      visit new_user_session_path
      expect(page).to have_content("Sign in with GoogleOauth2")
      mock_auth_hash_google_oauth2
      click_link "Sign in with GoogleOauth2"
      expect(page).to have_content 'Log out'
    end

    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      visit new_user_session_path
      expect(page).to have_content("Sign in with GoogleOauth2")
      click_link "Sign in with GoogleOauth2"
      expect(page).to_not have_content 'Log out'
      expect(page).to have_content('Could not authenticate')
    end
  end


end