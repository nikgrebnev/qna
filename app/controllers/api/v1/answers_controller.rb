class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @answers = question.answers
    render json: @answers
  end

  def show
    render json: answer
  end

  private

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

end