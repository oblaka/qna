require_relative '../feature_helper'

feature 'Edit answer', %q{
  In order to fix or improve answer
  As an authenticated user and author
  I can edit my answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'author can edit own question on show', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)
    within "#answer_#{answer.id}" do
      click_on "edit"
      fill_in 'Edit Answer', with: "You must going to sleep in this situation"
      click_on 'Save Answer'
    end
    within "#answer_#{answer.id}" do
      expect(page).to have_content 'You must going to sleep in this situation'
      expect(page).to_not have_selector 'textarea'
    end
    expect(page).to have_content 'Answer edited successfully!'
  end

  scenario 'non-author can not edit question on show' do
    sign_in(user)
    visit question_path(answer.question)
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link("edit")
    end
  end

  scenario 'non authenticated user question on show' do
    visit question_path(answer.question)
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link("edit")
    end
  end

end
