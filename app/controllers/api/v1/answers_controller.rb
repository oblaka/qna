class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: :create

  def index
    authorize Answer
    respond_with Answer.all
  end

  def create
    @answer = @question.answers.create( answer_params.merge( user: current_user ))
    authorize @answer
    respond_with @answer
    publish_answer
  end

  def show
    authorize @answer = Answer.find(params[:id])
    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find params[:question_id]
  end

  def publish_answer
    PrivatePub.publish_to "/question/#{@question.id}/answers", answer: {
      id: @answer.id, body: @answer.body,
      attachments: @answer.attachments.map { |att| { name: att.identifier, url: att.url } }
    }.to_json if @answer.valid?
  end
end
