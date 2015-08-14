require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it_behaves_like 'voting'

  describe 'POST #solution' do
    context 'question owner try set solution' do
      let!(:answer1) { create(:answer, question: question, best: false) }
      let!(:answer2) { create(:answer, question: question, best: true) }
      before do
        answer1
        answer2
        sign_in(question.user)
        post :solution, id: answer1, format: :js
      end
      it 'answer becomes solution' do
        expect(question.solution).to eq answer1
      end
      it 'remove best from other answers' do
        answer2.reload
        expect(answer2.best).to eq false
      end
    end
    context 'another user try set solution' do
      before do
        sign_in(answer.user)
        post :solution, id: answer, format: :js
      end
      it 'assign requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'response 403 forbidden' do
        expect( response ).to have_http_status( 403 )
      end
    end
    context 'unauthenticated try set solution' do
      it 'redirect to sign_in' do
        post :solution, id: answer, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      before { sign_in user }
      let(:post_create) do
        post :create, question_id: question.id,
          answer: attributes_for(:answer), format: :js
      end

      context 'with valid parameters' do
        it 'should save new answer in database' do
          expect { post_create }
          .to change(Answer, :count).by(1)
        end
        it 'render create template' do
          post_create
          expect(response).to render_template :create
        end
        it 'increases question answers count by 1' do
          expect { post_create }
          .to change(question.answers, :count).by(1)
        end
        it 'belongs to question' do
          post_create
          expect(assigns(:answer).question).to match question
        end
        it 'belongs to user' do
          post_create
          expect(assigns(:answer).user).to match user
        end

        it 'publish answer to channel' do
          channel = "/question/#{question.id}/answers"
          expect(PrivatePub).to receive(:publish_to).with(channel, anything)
          post_create
        end
      end

      context 'with invalid params' do
        let(:post_create) { post :create, question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        it 'does not save the answer' do
          expect { post_create }.to_not change(Answer, :count)
        end

        it 'render create template' do
          post_create
          expect(response).to render_template :create
        end
        it 'not publish answer to channel' do
          expect(PrivatePub).to_not receive(:publish_to)
          post_create
        end
      end
    end

    context 'non authenticated user' do
      it 'should not save new answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }
        .to_not change(Answer, :count)
      end
      it 'response is unauthorized status' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET #edit' do
    context 'user is owner of answer' do
      before do
        sign_in(answer.user)
        xhr :get, :edit, id: answer
      end
      it 'assign requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'user is not owner of answer' do
      before do
        sign_in(user)
        xhr :get, :edit, id: answer, format: :js
      end
      it 'assign requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end
      it 'response 403 forbidden' do
        expect( response ).to have_http_status( 403 )
      end
    end

    context 'non authenticated user' do
      before { xhr :get, :edit, id: answer }
      it 'redirect to sign_in' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update' do
    context 'answer owner' do
      before do
        sign_in(answer.user)
      end
      it 'assign requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end
      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update, id: answer, answer: { body: 'new fucking fucking body' }, format: :js
          answer.reload
          expect(answer.body).to eq 'new fucking fucking body'
        end
      end
      context 'with invalid attributes' do
        it 'not change answer attributes' do
          patch :update, id: answer, answer: { body: 'new body' }, format: :js
          answer.reload
          expect(answer.body).to eq 'You must going to sleep in this situation'
        end
      end
    end
    context 'not answer owner' do
      before do
        sign_in(user)
        patch :update, id: answer, answer: { body: 'new fucking body' }, format: :js
      end
      it 'not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'You must going to sleep in this situation'
      end
      it 'response 403 forbidden' do
        expect( response ).to have_http_status( 403 )
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'answer owner' do
      before { sign_in answer.user }
      it 'can delete answer' do
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render js delete' do
        answer
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated, but not owner' do
      before do
        sign_in user
        answer
      end
      it 'response 403 forbidden' do
        delete :destroy, id: answer, format: :js
        expect( response ).to have_http_status 403
      end
      it 'can not delete answer' do
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'non authenticated user' do
      it 'can not delete answer' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end
      it 'redirect to sign_in' do
        delete :destroy, id: answer, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST #good' do
    context 'authorized user' do
      it 'response ok' do
        sign_in(user)
        answer
        post :good, id: answer, format: :json
        expect(response).to have_http_status(200)
      end
    end
    context 'unauthorized user' do
      it 'response forbidden' do
        post :good, id: answer, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #shit' do
    context 'authorized user' do
      it 'response ok' do
        sign_in(user)
        answer
        post :shit, id: answer, format: :json
        expect(response).to have_http_status(200)
      end
    end
    context 'unauthorized user' do
      it 'response forbidden' do
        post :shit, id: answer, format: :json
        expect(response).to have_http_status(401)
      end
    end
  end
end
