require_relative '../feature_helper'

feature 'Attach file to answer', '
  In order to get illustrate answer
  As an answer author
  I can attach file to answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'user attach several files while create answer', js: true do
    within '.new_answer' do
      fill_in 'Type your answer', with: 'You must going to sleep in this situation'

      click_on 'add attachment'
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

      click_on 'Add an answer'
    end

    expect(page).to have_content 'Your answer successfully created'

    within '.answers' do
      expect(page).to have_content 'You must going to sleep in this situation'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario 'user can delete one of files while edit answer', js: true do
    within '.new_answer' do
      fill_in 'Type your answer', with: 'You must going to sleep in this situation'
      click_on 'add attachment'
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Add an answer'
    end
    visit question_path(question)
    within '#answer_1' do
      click_on 'edit'
      check 'spec_helper.rb'
      click_on 'Save Answer'
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
