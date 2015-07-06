require_relative '../feature_helper'

feature 'Vote for question', %q{
  In order to affect on question rating
  As an authenticated user
  I can increase or decrease rating
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  context 'authenticated user' do
    before do
      sign_in user
      visit question_path answer.question
    end

    scenario 'can increase rating on 1', js: true do
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('0')
      end
      click_on('+')
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('1')
      end
    end

    scenario 'can not vote twice', js: true do
      expect(page).to_not have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to_not have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to have_css("#revoke_answer_#{answer.id}.disabled")
      click_on('+')
      expect(page).to have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to_not have_css("#revoke_answer_#{answer.id}.disabled")
    end

    scenario 'can revoke his vote after vote', js: true do
      click_on('+')
      expect(page).to have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to_not have_css("#revoke_answer_#{answer.id}.disabled")
      expect(page).to have_css("#revoke_answer_#{answer.id}")
      click_on('X')
      expect(page).to have_css("#good_answer_#{answer.id}")
      expect(page).to have_css("#shit_answer_#{answer.id}")
      expect(page).to_not have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to_not have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to have_css("#revoke_answer_#{answer.id}.disabled")
    end

    scenario 'can vote after revoke', js: true do
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('0')
      end
      click_on('-')
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('-1')
      end
      expect(page).to have_css("#shit_answer_#{answer.id}.disabled")
      click_on('X')
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('0')
      end
      click_on('+')
      within "#rating_answer_#{answer.id}" do
        expect(page).to have_content('1')
      end
    end
  end

  context 'authenticated author' do
    scenario 'can not vote', js: true do
      sign_in answer.user
      visit question_path answer.question
      expect(page).to have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to have_css("#revoke_answer_#{answer.id}.disabled")
    end
  end

  context 'unauthenticated user ' do
    scenario 'can not vote', js: true do
      visit question_path answer.question
      expect(page).to have_css("#good_answer_#{answer.id}.disabled")
      expect(page).to have_css("#shit_answer_#{answer.id}.disabled")
      expect(page).to have_css("#revoke_answer_#{answer.id}.disabled")
    end
  end

end
