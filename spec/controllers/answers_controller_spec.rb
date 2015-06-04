require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:answer) { create(:answer) }

  describe 'POST #create' do
    let!(:question) { create(:question) }
    context 'with valid parameters' do
      it 'should save new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
        .to change(Answer, :count).by(1)
      end
      it 'redirects to question show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
      it 'increases question answers count by 1' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
        .to change(question.answers, :count).by(1)
      end
      it 'belongs to question' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(assigns(:answer).question).to match question
      end
    end

    context 'with invalid params' do
      it 'does not save the answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }
        .to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        post :create, question_id: answer.question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end

  describe "DELETE #destroy" do
    it 'delete question' do
      answer
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end
    it 'render associated question' do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(answer.question)
    end
  end

end
