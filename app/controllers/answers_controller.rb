class AnswersController < ApplicationController
  before_action :authenticate_user!
  include Voted
  after_action :publish_answer, only: [:create]

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

  private

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
        "question_#{answer.question.id}",
        { event: 'new_answer',
          answer: answer,
          question_author_id: answer.question.user_id
        }
    )
  end

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
