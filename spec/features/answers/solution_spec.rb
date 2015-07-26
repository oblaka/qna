require_relative '../feature_helper'

feature 'Mark Answer as Solution', '
  In order to
  As an question author
  I can mark answer as solution
' do
  given(:question) { create(:question) }
  given(:another_user) { create(:user) }
  given!(:answer1) { create(:answer1, question: question) }
  given!(:answer2) { create(:answer2, question: question) }

  scenario 'first answer is solution' do
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content(answer1.body)
      expect(page).to have_content(answer2.body)
    end
    expect(first('.answers p')).to have_content(question.solution.body)
  end

  context 'authenticated user' do
    context 'question owner' do
      before do
        sign_in(question.user)
        visit question_path(question)
      end
      scenario 'can mark answer as solution', js: true do
        within "#answer_#{answer1.id}" do
          expect(page).to have_link('Mark as Solution')
        end
      end
      scenario 'choosing solution changes answer order', js: true do
        expect(first('.answers p')).to have_content(answer2.body)
        within "#answer_#{answer1.id}" do
          click_on 'Mark as Solution'
        end
        sleep 1
        expect(page).to have_content 'The best answer is chosen'
        expect(first('.answers p')).to have_content(answer1.body)
      end
    end
    context 'another user' do
      scenario 'can not mark best answer as solution' do
        sign_in(another_user)
        visit question_path(answer1.question)
        within "#answer_#{answer1.id}" do
          expect(page).to_not have_link('Mark as Solution')
        end
      end
    end
  end

  context 'non-authenticated user' do
    scenario 'can not mark best answer as solution' do
      visit question_path(answer1.question)
      within "#answer_#{answer1.id}" do
        expect(page).to_not have_link('Mark as Solution')
      end
    end
  end
end
