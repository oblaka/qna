require 'rails_helper'

feature 'Edit question', %q{
  In order to improve question details
  As an question owner
  I can edit question
} do

  given(:another_user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'question owner see edit button and can edit question' do
    sign_in(question.user)
    visit question_path(question)
    expect(page).to have_content(question.title)
    within page.find("#question_#{question.id}") do
      find(:link, "edit").click
    end
    fill_in 'Your question', with: 'Ritorical question'
    fill_in 'more details', with: 'Ritorical question details'
    click_on 'save question'
    expect(page).to have_content('Ritorical question')
  end

  scenario 'foreign user not see edit button and can not edit question' do
    sign_in(another_user)
    visit question_path(question)
    expect(page).to_not have_content('edit')
    expect(page.find("#question_#{question.id}")).to have_no_link("edit")

  end

  scenario 'foreign user not see edit button and can not edit question' do
    sign_in(another_user)
    visit question_path(question)
    expect(page.find("#question_#{question.id}")).to have_no_link("edit")
  end

end
