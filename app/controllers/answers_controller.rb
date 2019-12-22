class AnswersController < ApplicationController

  def new

  end

  def create
    if answer.save
      redirect_to answer
    else
      render :new
    end
  end
  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new(answer_params)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
