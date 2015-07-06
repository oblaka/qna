require_relative '../feature_helper'

feature 'Vote for question', %q{
  In order to affect on question rating
  As an authenticated user
  I can increase or decrease rating
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }

  context 'authenticated user' do
    before do
      sign_in user
      visit question_path question
    end

    scenario 'two users increase rating on 2 by 1', js: true do
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('0')
      end
      click_on('good!')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('1')
      end
      sign_out
      sign_in another_user
      visit question_path question
      click_on('good!')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('2')
      end
    end

    scenario 'can not vote twice', js: true do
      expect(page).to_not have_css("#good_question_#{question.id}.disabled")
      click_on('good!')
      expect(page).to have_css("#good_question_#{question.id}.disabled")
    end

    scenario 'can revoke his vote after vote', js: true do
      expect(page).to have_css("#good_question_#{question.id}")
      expect(page).to_not have_css("#good_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}.disabled")
      click_on('good!')
      expect(page).to have_css("#revoke_question_#{question.id}")
      expect(page).to_not have_css("#revoke_question_#{question.id}.disabled")
      expect(page).to have_css("#good_question_#{question.id}.disabled")
    end

    scenario 'can vote after revoke', js: true do
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('0')
      end
      click_on('shit!')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('-1')
      end
      expect(page).to have_css("#good_question_#{question.id}.disabled")
      expect(page).to have_css("#shit_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}")
      expect(page).to_not have_css("#revoke_question_#{question.id}.disabled")
      click_on('revoke')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('0')
      end
      expect(page).to have_css("#good_question_#{question.id}")
      expect(page).to have_css("#shit_question_#{question.id}")
      expect(page).to_not have_css("#good_question_#{question.id}.disabled")
      expect(page).to_not have_css("#shit_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}.disabled")
      click_on('good!')
      within "#rating_question_#{question.id}" do
        expect(page).to have_content('1')
      end
      expect(page).to have_css("#good_question_#{question.id}.disabled")
      expect(page).to have_css("#shit_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}")
      expect(page).to_not have_css("#revoke_question_#{question.id}.disabled")
    end
  end

  context 'authenticated author' do
    scenario 'can not vote', js: true do
      sign_in question.user
      visit question_path question
      expect(page).to have_css("#good_question_#{question.id}.disabled")
      expect(page).to have_css("#shit_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}.disabled")
    end
  end

  context 'unauthenticated user ' do
    scenario 'can not vote', js: true do
      visit question_path question
      expect(page).to have_css("#good_question_#{question.id}.disabled")
      expect(page).to have_css("#shit_question_#{question.id}.disabled")
      expect(page).to have_css("#revoke_question_#{question.id}.disabled")
    end
  end

end
