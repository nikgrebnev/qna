class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user
    answer.save
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
    end
  end

  def update
    answer.update(answer_params)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new(answer_params.merge(question: question))
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end


  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
