require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let(:user) { create(:user) }
  let(:answer) { create(:answer) }
  let(:question) { create(:question) }

  describe 'POST #comment' do
    context 'question commenting by' do
      context 'authenticated user' do
        before {sign_in user }
        it 'create comment in db' do
          expect { post :create, question_id: question, commentable: 'questions', comment: {body: 'Awesome!'}, format: :js }.to change(Comment, :count).by 1
        end
        it 'response ok' do
          expect(response).to have_http_status(200)
        end
      end
      context 'unauthenticated user' do
        it 'not create comment in db' do
          expect { post :create, question_id: question, commentable: 'questions', comment: {body: 'Awesome!'}, format: :js }
          .to_not change(Comment, :count)
        end
        it 'response forbidden' do
          post :create, question_id: question, commentable: 'questions', comment: {body: 'Awesome!'}, format: :js
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'answer commenting by' do
      context 'authenticated user' do
        before {sign_in user }
        it 'create comment in db' do
          expect { post :create, answer_id: answer, commentable: 'answers', comment: {body: 'Awesome!'}, format: :js }.to change(Comment, :count).by 1
        end
        it 'response ok' do
          expect(response).to have_http_status(200)
        end
      end
      context 'unauthenticated user' do
        it 'not create comment in db' do
          expect { post :create, answer_id: answer, commentable: 'answers', comment: {body: 'Awesome!'}, format: :js }
          .to_not change(Comment, :count)
        end
        it 'response forbidden' do
          post :create, answer_id: answer, commentable: 'answers', comment: {body: 'Awesome!'}, format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'GET #new' do
    context 'question' do
      context 'authenticated user' do
        before do
          sign_in user
          xhr :get, :new, question_id: question, commentable: 'questions', format: :js
        end
        it 'assigns new comment to @comment' do
          expect(assigns(:comment)).to be_a_new(Comment)
        end
        it 'response ok' do
          expect(response).to have_http_status(200)
        end
      end
      context 'unauthenticated user' do
        it 'response forbidden' do
          xhr :get, :new, question_id: question, commentable: 'questions', format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
    context 'answer' do
      context 'authenticated user' do
        before do
          sign_in user
          xhr :get, :new, answer_id: answer, commentable: 'answers', format: :js
        end
        it 'assigns new comment to @comment' do
          expect(assigns(:comment)).to be_a_new(Comment)
        end
        it 'response ok' do
          expect(response).to have_http_status(200)
        end
      end
      context 'unauthenticated user' do
        it 'response forbidden' do
          xhr :get, :new, answer_id: answer, commentable: 'answers', format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
  end

end
