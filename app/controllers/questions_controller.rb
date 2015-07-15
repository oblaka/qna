class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:index, :new, :create]

  include Voting

  def index
    respond_with( @questions = Question.all )
  end

  def show
    respond_with @question
  end

  def new
    respond_with( @question = current_user.questions.build )
  end

  def edit
    redirect_to questions_path, notice: 'It is not yours question!' unless owner?
  end

  def create
    respond_with( @question = current_user.questions.create(question_params) )
    PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
  end

  def update
    unless owner?
      redirect_to @question, alert: 'It is not yours question!'
    else
      @question.update(question_params)
      respond_with @question
    end
  end

  def destroy
    unless owner?
      redirect_to @question, alert: 'It is not yours question!'
    else
      respond_with @question.destroy
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
