class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: User

  def index
    @questions = Question.all
#    pp @questions
    render json: @questions
  end
end