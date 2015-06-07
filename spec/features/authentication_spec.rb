require 'rails_helper'

feature 'Authentication', %q{
  In order to authenticate
  As an registered user
  I can sign in and logout
} do

  given(:user) { create(:user) }
  given(:new_user) { build(:user) }

  scenario 'Non-registered can not sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'
    expect(page).to have_content 'Invalid email or password.'
    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Sign up'
  end

  scenario 'Non-registered user can be registered' do
    visit new_user_registration_path
    fill_in 'Email', with: new_user.email
    fill_in 'Password', with: new_user.password
    fill_in 'Password confirmation', with: new_user.password
    click_button 'Sign up'
    expect(page).to have_content 'You have signed up successfully.'
    expect(page).to have_content 'Logout'
  end

  scenario "Registered user can sign in" do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content 'Logout'
  end

  scenario 'Authenticated user can logout' do
    sign_in(user)
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq(root_path)
  end

end
