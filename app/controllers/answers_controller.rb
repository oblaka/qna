class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :solution]
  before_action :permission_check, only: [:edit, :update, :destroy, :solution]
  after_action :publish_answer, only: :create

  respond_to :js
  include Voting

  def create
    @answer = @question.answers.create( answer_params.merge( user: current_user ))
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
    @answer.is_solution
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
  end

  def permission_check
    checked_object = action_name == 'solution' ? @answer.question : @answer
    return if checked_object.user_id == current_user.id
    render status: :forbidden
  end

  def publish_answer
    PrivatePub.publish_to "/question/#{@question.id}/answers", answer: {
      id: @answer.id, body: @answer.body,
      attachments: @answer.attachments.map { |att| { name: att.identifier, url: att.url} }
    }.to_json if @answer.valid?
  end

end
