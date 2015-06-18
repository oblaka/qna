require_relative 'feature_helper'

feature 'Delete question', %q{
  In order to keep only actual questions
  As an authenticated user and author
  I can delete my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'author can delete own question on show' do
    sign_in(question.user)
    visit question_path(question)
    within "#question_#{question.id}" do
      click_on "delete"
    end
    expect(page).to have_content 'Your question successfully deleted.'
  end

  scenario 'non-author can not delete question on show' do
    sign_in(user)
    visit question_path(question)
    within "#question_#{question.id}" do
      expect(page).to have_no_link("delete")
    end
  end

  scenario 'non authenticated user question on show' do
    visit question_path(question)
    within "#question_#{question.id}" do
      expect(page).to have_no_link("delete")
    end
  end

end
