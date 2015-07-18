require_relative '../feature_helper'

feature 'Facebook Authentication', %q{
  In order to authenticate
  As an registered user
  I can sign in and logout
} do

  given(:registered_user) { create(:user, email: 'user@mail.com') }
  given(:new_user) { build(:user, confirmed_at: nil) }
  given(:auth) { create(:fb_auth, user: registered_user) }


  context 'user already have facebook auth' do
    scenario 'can sign in by facebook', js: true do
      auth_with :facebook, auth.user.email
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from facebook account.'
      expect(page).to have_content 'Logout'
    end
  end

  context 'user not have facebook auth yet' do
    context 'oauth hash with email' do
      scenario 'can sign in by facebook', js: true do
        registered_user
        auth_with :facebook, registered_user.email
        visit new_user_session_path
        click_on 'Sign in with Facebook'
        expect(page).to have_content 'Successfully authenticated from facebook account.'
        expect(page).to have_content 'Logout'
      end
    end

    context 'oauth hash without email' do
      scenario 'can sign in by facebook after confirm email' do
        auth_with :facebook
        visit new_user_session_path
        click_on 'Sign in with Facebook'
        fill_in 'user_email', with: new_user.email
        click_on 'confirm email'
        open_email(new_user.email)
        current_email.click_link 'Confirm my account'
        expect(page).to have_content "Hello, #{new_user.email}!"
        expect(page).to have_content 'Logout'
      end
    end
  end
end
