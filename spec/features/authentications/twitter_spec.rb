require_relative '../feature_helper'

feature 'Twitter Authentication', '
  In order to authenticate
  As an registered user
  I can sign in and logout
' do
  given(:registered_user) { create(:user, email: 'user@mail.com') }
  given(:new_user) { build(:user, confirmed_at: nil) }
  given(:auth) { create(:fb_auth, user: registered_user) }

  context 'user already have twitter auth' do
    scenario 'can sign in by twitter', js: true do
      auth_with :twitter, auth.user.email
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from twitter account.'
      expect(page).to have_content 'Logout'
    end
  end

  context 'user not have twitter auth yet' do
    context 'oauth hash without email' do
      scenario 'can sign in by twitter after confirm email' do
        auth_with :twitter
        visit new_user_session_path
        click_on 'Sign in with Twitter'
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
