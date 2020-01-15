class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user
    if answer.save
      flash[:notice] = "Successfully added."
      redirect_to  question
    else
      flash.now[:alert] = "Unable to add!"
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Deleted successfully'
    else
      flash[:alert] = "You can not delete"
    end
    redirect_to answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new(answer_params.merge(question: question))
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
