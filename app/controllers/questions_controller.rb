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
    @question = current_user.questions.build
    authorize Question
    respond_with( @question )
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)
    authorize @question
    respond_with( @question )
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.valid?
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find params[:id]
    authorize @question
  end
end
