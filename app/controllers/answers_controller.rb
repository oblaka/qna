class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :solution]

  respond_to :js
  include Voting

  def create
    @answer = @question.answers.create( answer_params.merge( user: current_user ))
    authorize @answer
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @question = @answer.question
    respond_with @answer.destroy
  end

  def solution
    @answer.set_solution
    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find params[:question_id]
  end

  def load_answer
    @answer = Answer.find params[:id]
    authorize @answer
  end
end
