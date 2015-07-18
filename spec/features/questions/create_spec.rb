require_relative '../feature_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user create the question with valid attributes' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask a Question'
    find_field('Your question').value == ''
    fill_in 'Your question', with: question.title
    fill_in 'more details', with: question.body
    click_on 'save question'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content question.title
  end

  scenario 'Authenticated user cannot add question with invalid attributes' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask a Question'
    fill_in 'Your question', with: 'quest'
    fill_in 'more details', with: 'what?'
    click_on 'save question'

    expect(page).to have_content 'Question could not be created.'
    expect(page).to have_text 'is too short'
    find_field('Your question').value == 'quest'
  end

  scenario 'Non-authenticated user try to create question' do
    visit '/questions'
    click_on 'Ask a Question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to have_button 'Log in'
  end

end
