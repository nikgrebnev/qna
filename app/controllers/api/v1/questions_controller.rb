class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @questions = Question.all
#    pp @questions
    render json: @questions.to_json(include: :answers)
  end
end