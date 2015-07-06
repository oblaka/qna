class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:index, :new, :create]

  include Voting

  def index
    @questions = Question.all
  end

  def show
    unless current_user.nil?
      @new_answer = @question.answers.build
    end
  end

  def new
    @question = current_user.questions.build
  end

  def edit
    redirect_to questions_path, notice: 'It is not yours question!' unless owner?
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json
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
    params.require(:question).permit(:title, :body,
                                     attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find params[:id]
  end

  def owner?
    @question.user_id == current_user.id
  end

end
