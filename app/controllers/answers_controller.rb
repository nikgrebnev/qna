class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @answer = question.answers.new()
    @answer.user = current_user
  end

  def create
    answer.user = current_user
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Answer delete successfully'
    else
      flash[:alert] = "You can not delete"
    end
    redirect_to answer.question
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
