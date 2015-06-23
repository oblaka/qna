class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :solution]

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    respond_to do |format|
      if @answer.save
        @new_answer = @question.answers.build
        format.js   { render 'create' }
        format.html   { redirect_to @question, notice: 'Answer create wia HTML' }
      else
        @new_answer = @answer
        format.js   { render 'create_fail' }
      end
    end
  end

  def edit
    if owner?
      render 'edit'
    else
      redirect_to @answer.question, alert: "It's not your answer!"
    end
  end

  def update
    if owner?
      if @answer.update(answer_params)
        render 'update'
      else
        render 'edit'
      end
    else
      redirect_to @answer.question, alert: "It's not your answer!"
    end
  end

  def destroy
    @question = @answer.question
    if owner?
      @answer.destroy
      render 'delete'
    else
      redirect_to @question, alert: "It's not your answer!"
    end
  end

  def solution
    @question = @answer.question
    if @question.user_id == current_user.id
      @answer.is_solution
      @question.reload
    else
      redirect_to @question, alert: "It's not your question!"
    end
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

  def owner?
    @answer.user_id == current_user.id
  end

end
