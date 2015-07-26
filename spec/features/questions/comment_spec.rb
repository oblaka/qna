require_relative '../feature_helper'

feature 'Commenting question', '
  In order to share my opinion
  As an authenticated user
  I can add comments to question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'authenticated user' do
    scenario 'can comment', js: true  do
      sign_in user
      visit question_path(question)
      within "#question_#{question.id}" do
        click_on 'comment'
      end
      fill_in 'comment_body', with: 'some text'
      click_on 'add comment'
      within "#comments_question_#{question.id}" do
        expect(page).to have_content 'some text'
      end
    end
  end

  context 'un-authenticated user' do
    scenario 'can not comment', js: true  do
      visit question_path(question)
      within "#comments_question_#{question.id}" do
        expect(page).to_not have_link 'comment'
      end
    end
  end
end
