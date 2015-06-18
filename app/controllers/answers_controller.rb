class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:edit, :update, :destroy, :solution]

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

  def edit
    respond_to do |format|
      if owner?
        format.js   { render 'edit' }
      else
        format.js   { redirect_to @answer.question, alert: "It's not your answer!" }
      end
    end
  end

  def update
    respond_to do |format|
      if owner?
        if @answer.update(answer_params)
          format.js   { render 'update' }
        else
          format.js   { render 'edit' }
        end
      else
        format.js   { redirect_to @answer.question, alert: "It's not your answer!" }
      end
    end
  end

  def destroy
    @question = @answer.question
    respond_to do |format|
      if owner?
        @answer.destroy
        format.js   { render 'delete' }
      else
        format.js   { redirect_to @question, alert: "It's not your answer!" }
      end
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
    params.require(:answer).permit(:body)
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
