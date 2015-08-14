require_relative '../feature_helper'

feature 'Attach file to question', '
  In order to get illustrate question
  As an question author
  I can attach file to question
' do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'user attach some files while create question', js: true do
    fill_in 'Your question', with: question.title
    fill_in 'more details', with: question.body
    click_on 'add attachment'
    click_on 'add attachment'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'save question'
    sleep 1
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'user can delete one of files while edit question', js: true do
    fill_in 'Your question', with: question.title
    fill_in 'more details', with: question.body
    click_on 'add attachment'
    click_on 'add attachment'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'save question'
    click_on 'edit'
    check 'spec_helper.rb'
    click_on 'save question'
    sleep 1
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
