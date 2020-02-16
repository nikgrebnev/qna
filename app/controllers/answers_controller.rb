class AnswersController < ApplicationController
  before_action :authenticate_user!
  include Voted

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
    if current_user.author?(answer)
      answer.update(answer_params)
    end
  end

  def make_best
    if current_user.author?(question)
      answer.make_best!
    end
  end

  def show
#    @link_classes = answer.create_vote_links(current_user)
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new(answer_params.merge(question: question))
  end

  def question
    @question ||= params[:question_id] ? Question.with_attached_files.find(params[:question_id]) : answer.question
  end

  helper_method :answer
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
