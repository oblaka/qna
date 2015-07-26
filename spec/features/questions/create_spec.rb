require_relative '../feature_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
' do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user create the question with valid attributes' do
    sign_in(user)

    visit '/questions'
    click_on 'Ask a Question'
    expect(find_field('Your question').value).to eq nil
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
    expect(find_field('Your question').value).to eq 'quest'
  end

  scenario 'Non-authenticated user try to create question' do
    visit '/questions'
    expect(page).to_not have_button 'Ask a Question'
    expect(page).to have_link 'Sign in'
  end
end
