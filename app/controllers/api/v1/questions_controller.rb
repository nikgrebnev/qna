class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question
  end

  def create
    if question.save
      render json: question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if question.destroy
      head :ok
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_resource_owner.questions.new(question_params)
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:name, :reward_file])
  end

end