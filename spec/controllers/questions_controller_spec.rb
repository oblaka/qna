require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:invalid_question) { new(:invalid_question) }
  let(:questions) { create_list(:question, 2) }

  it_behaves_like 'voting'

  describe 'GET #index' do
    before { get :index }
    it 'populates array of questions' do
      expect(assigns(:questions)).to match_array @questions
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'any user' do
      before { get :show, id: question }
      it 'assign requested question to @question' do
        expect(assigns(:question)).to eq question
      end
      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
        get :show, id: question
      end
    end

    context 'non-authenticated user' do
      it 'assigns nil to @new_answer' do
        expect(assigns(:new_answer)).to eq nil
      end
    end
  end

  describe 'GET #new' do
    before do
      sign_in(user)
      get :new
    end
    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context 'user is owner of question' do
      before do
        sign_in(question.user)
        get :edit, id: question
      end
      it 'assign requested question to @question' do
        expect(assigns(:question)).to eq question
      end
      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'user is not owner of question' do
      before do
        sign_in(user)
        get :edit, id: question
      end
      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
      it 'show warning' do
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }
    context 'valid question params' do
      let(:post_create) { post :create, question: attributes_for(:question) }
      it 'save question in db' do
        expect { post_create }.to change(Question, :count).by(1)
      end
      it 'belongs to user' do
        post_create
        expect(assigns(:question).user).to match user
      end
      it 'render show view' do
        post_create
        expect(response).to redirect_to question_path(assigns(:question))
      end
      it 'show success notice' do
        post_create
        expect(flash[:notice]).to have_content 'Question was successfully created.'
      end
      it 'publish question to channel' do
        channel = "/questions"
        expect(PrivatePub).to receive(:publish_to).with(channel, anything)
        post_create
      end
    end
    context 'invalid question params' do
      let(:post_create) { post :create, question: attributes_for(:invalid_question) }
      it 'not save question in db' do
        expect { post_create }.to_not change(Question, :count)
      end
      it 'render edit view' do
        post_create
        expect(response).to render_template :new
      end
      it 'not publish question to channel' do
        expect(PrivatePub).to_not receive(:publish_to)
        post_create
      end
    end
  end

  describe 'PATCH #update' do
    context 'owner patch question' do
      before { sign_in(question.user) }
      context 'valid question params' do
        it 'assign requested question to @question' do
          patch :update, id: question, question: attributes_for(:question)
          expect(assigns(:question)).to eq question
        end
        it 'change question attributes' do
          patch :update, id: question, question: { title: 'new title', body: 'new large body' }
          question.reload
          expect(question.title).to eq('new title')
          expect(question.body).to eq('new large body')
        end
        it 'redirect to question' do
          patch :update, id: question, question: { title: 'new title', body: 'new large body' }
          expect(response).to redirect_to question
        end
        it 'show notice' do
          patch :update, id: question, question: { title: 'new title', body: 'new large body' }
          expect(flash[:notice]).to have_content 'Question was successfully updated.'
        end
      end
      context 'invalid question params' do
        before { patch :update, id: question, question: { title: 'new title', body: nil } }
        it 'dont change question attributes' do
          question.reload
          expect(question.title).to eq('My Question')
          expect(question.body).to eq('My Detailed shit')
        end
        it 're-render edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'another (not owner) user patch question' do
      before { sign_in(user) }
      it 'assign requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end
      it 'not change question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new large body' }
        question.reload
        expect(question.title).to eq('My Question')
        expect(question.body).to eq('My Detailed shit')
      end
      it 'redirect to question' do
        patch :update, id: question, question: { title: 'new title', body: 'new large body' }
        expect(response).to redirect_to root_path
      end
      it 'show alert' do
        patch :update, id: question, question: { title: 'new title', body: 'new large body' }
        expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'owner can' do
      before { sign_in(question.user) }
      it 'delete question' do
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end
      it 'redirects to questions #index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end
  end

  context 'another_user can not' do
    before { sign_in(user) }
    it 'delete question' do
      question
      expect { delete :destroy, id: question }.to_not change(Question, :count)
    end

    it 'rendirect to question' do
      question
      delete :destroy, id: question
      expect(response).to redirect_to root_path
    end

    it 'rendirect to question' do
      question
      delete :destroy, id: question
      expect(flash[:alert]).to have_content 'You are not authorized to perform this action.'
    end
  end
end
