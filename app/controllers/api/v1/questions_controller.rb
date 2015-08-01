class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :answers]

  def index
    authorize Question
    respond_with Question.all
  end

  def show
    respond_with @question
  end

  def answers
    # render nothing: true, status: :success
    respond_with @question.answers
  end

  def create
    authorize @question = current_user.questions.create(question_params)
    respond_with( @question )
    PrivatePub.publish_to '/questions', question: @question.to_json if @question.valid?
  end

  private

  def load_question
    @question = Question.find(params[:id])
    authorize @question
    # skip_authorization
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
