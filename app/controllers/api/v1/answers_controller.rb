class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = question.answers
    render json: @answers
  end

  def show
    render json: answer
  end

  def create
    answer.user = current_resource_owner
    if answer.save
      render json: answer
    else
      render_error(answer)
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      render_error(answer)
    end
  end

  def destroy
    if answer.destroy
      head :ok
    else
      render_error(answer)
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new(answer_params.merge(question: question))
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end