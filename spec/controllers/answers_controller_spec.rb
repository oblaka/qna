require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { sign_in user }

      context 'with valid parameters' do
        it 'should save new answer in database' do
          expect { post :create, question_id: question.id, answer: attributes_for(:answer),format: :js }
          .to change(Answer, :count).by(1)
        end
        it 'render create template' do
          post :create, question_id: question.id, answer: attributes_for(:answer),format: :js
          expect(response).to render_template :create
        end
        it 'increases question answers count by 1' do
          expect { post :create, question_id: question.id, answer: attributes_for(:answer),format: :js }
          .to change(question.answers, :count).by(1)
        end
        it 'belongs to question' do
          post :create, question_id: question.id, answer: attributes_for(:answer),format: :js
          expect(assigns(:answer).question).to match question
        end
        it 'belongs to user' do
          post :create, question_id: question.id, answer: attributes_for(:answer),format: :js
          expect(assigns(:answer).user).to match user
        end
      end

      context 'with invalid params' do
        it 'does not save the answer' do
          expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer),format: :js }
          .to_not change(Answer, :count)
        end

        it 'redirects to question show view' do
          post :create, question_id: answer.question.id, answer: attributes_for(:answer),format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'non authenticated user' do
      it 'should not save new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer),format: :js }
        .to_not change(Answer, :count)
      end
    end
  end

  describe "DELETE #destroy" do

    context 'answer owner' do

      before {sign_in answer.user }
      it 'can delete answer' do
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        answer
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(answer.question)
      end
      it 'show notice' do
        answer
        delete :destroy, id: answer
        expect(flash[:notice]).to have_content 'Answer destroyed successfully!'
      end
    end

    context 'authenticated, but not owner' do
      before do
        sign_in user
        answer
      end
      it 'can not delete answer' do
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(answer.question)
      end

      it 'alert about ownership' do
        delete :destroy, id: answer
        expect(flash[:alert]).to have_content "It's not your answer!"
      end
    end

    context 'non authenticated user' do
      it 'can not delete answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end
      it 'redirect to sign_in' do
        delete :destroy, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
