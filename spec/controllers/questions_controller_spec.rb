require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }
  let(:invalid_question) { new(:invalid_question) }
  let(:questions) { create_list(:question, 2) }

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
    before { get :show, id: question }
    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'assigns new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, id: question }
    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'valid question params' do
      it "save question in db" do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'render show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'invalid question params' do
      it 'not save question in db' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'render edit view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
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
    end
    context 'invalid question params' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }
      it 'dont change question attributes' do
        question.reload
        expect(question.title).to eq('My Question')
        expect(question.body).to eq('Detailed shit')
      end
      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'delete question' do
      question
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end
    it 'render index view' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

end
