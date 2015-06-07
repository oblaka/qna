require 'rails_helper'

feature 'Create answers', %q{
  In order to help questioner
  As an authenticated user
  I can create answer
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'authenticated user can create answer' do
    sign_in user
    visit question_path question
    expect(page).to have_content 'Type your answer'
    fill_in 'Type your answer', with: "You must going to sleep in this situation"
    click_on 'Add an answer'
    expect(page).to have_content "You must going to sleep in this situation"
    expect(page).to have_content 'Your answer successfully created.'
    find_field('Type your answer').value == ''
  end

  scenario 'authenticated user with invalid params' do
    sign_in user
    visit question_path question
    expect(page).to have_content 'Type your answer'
    fill_in 'Type your answer', with: 'RTFM'
    click_on 'Add an answer'
    expect(page).to have_content 'is too short'
    expect(page).to_not have_content 'Your answer successfully created.'
    find_field('Type your answer').value == 'RTFM'
  end

  scenario 'non-authenticated user must authenticate to create answer' do
    visit question_path question
    expect(page).to_not have_content 'Type your answer'
    expect(page).to have_content 'Sign in'
  end

end