class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    respond_to do |format|
      if @answer.save
        @new_answer = @question.answers.build(user: current_user)
        format.js   { render 'create' }
      else
        @new_answer = @answer
        format.js   { render 'create_fail' }
      end
    end
  end

  def destroy
    @answer = Answer.find params[:id]
    @question = @answer.question
    if @answer.user_id == current_user.id
      @answer.destroy
      redirect_to @question, notice: 'Answer destroyed successfully!'
    else
      redirect_to @question, alert: "It's not your answer!"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find params[:question_id]
  end

end
