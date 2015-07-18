require_relative '../feature_helper'

feature 'Add Auth to user', %q{
  In order to be able to login with various providers
  As an authenticated user
  I can add oauth authorization to my profile
} do

  given(:user) { create(:user) }
  given(:auth) { create(:fb_auth, uid: '12345') }

  context 'authenticated user' do
    before do
      sign_in(user)
      visit profile_path
    end
    scenario 'can add  auth if it not exist yet', js: true do
      auth_with :vkontakte
      click_on 'Add Vkontakte authorization'
      expect(page).to have_content 'Successfully added authentication from vkontakte to your account.'
      expect(page).to have_content 'vkontakte'
      expect(page).to have_content '12345'
    end
    scenario 'can not add auth auth if it already exist', js: true do
      auth
      auth_with :facebook
      click_on 'Add Facebook authorization'
      expect(page).to have_content "Someone already used this facebook account to authenication. And he can logout and sign in via facebook. Isn't you?"
    end
  end
end
