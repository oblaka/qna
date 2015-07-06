require_relative '../feature_helper'

feature 'Commenting answer', %q{
  In order to share my opinion
  As an authenticated user
  I can add comments to answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  context 'authenticated user' do
    scenario 'can comment', js: true  do
      sign_in user
      visit question_path(answer.question)
      within "#answer_#{answer.id}" do
        click_on 'comment'
        sleep 1
      end
      fill_in 'comment_body', with: 'some text'
      click_on 'add comment'
      within "#comments_answer_#{answer.id}" do
        expect(page).to have_content 'some text'
      end
    end
  end

  context 'un-authenticated user' do
    scenario 'can not comment', js: true  do
      visit question_path(answer.question)
      within "#answer_#{answer.id}" do
        expect(page).to_not have_link 'comment'
      end
    end
  end

end
