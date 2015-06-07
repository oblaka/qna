class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build unless current_user.nil?
  end

  def new
    @question = current_user.questions.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    unless owner?
      redirect_to @question, alert: 'It is not yours question!'
    else
      if @question.update(question_params)
        redirect_to @question, notice: 'Your question successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    unless owner?
      redirect_to @question, alert: 'It is not yours question!'
    else
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find params[:id]
  end

  def owner?
    @question.user_id == current_user.id
  end

end
