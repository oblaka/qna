class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
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
