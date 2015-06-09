require 'rails_helper'

feature 'Delete question', %q{
  In order to keep only actual answers
  As an authenticated user and author
  I can delete my answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'author can delete own question on show' do
    sign_in(answer.user)
    visit question_path(answer.question)
    within page.find("#answer_#{answer.id}") do
      find(:link, "delete").click
    end
    expect(page).to have_content 'Answer destroyed successfully!'
  end

  scenario 'non-author can not delete question on show' do
    sign_in(user)
    visit question_path(answer.question)
    expect(page.find("#answer_#{answer.id}")).to have_no_link("delete")

  end

  scenario 'non authenticated user question on show' do
    visit question_path(answer.question)
    expect(page.find("#answer_#{answer.id}")).to have_no_link("delete")
  end

end
