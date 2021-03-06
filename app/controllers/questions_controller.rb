class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :question, only: %i[destroy update]
  authorize_resource
  include Voted
  after_action :publish_question, only: [:create]
  before_action :find_subscription, only: %i[show update]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def edit
  end

  def create
    if question.save
      redirect_to question, notice: 'Successfully added.'
    else
      flash.now[:alert] = "Unable to add!"
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    flash[:notice] = 'Deleted successfully'
    redirect_to questions_path
  end

  private

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        { event: 'new_question',
          data: ApplicationController.render( partial: 'questions/question', locals: { question: question} )
        }
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_user.questions.new(question_params)
  end
  helper_method :question

  def answer
    @answer ||= question.answers.new(user: current_user)
  end
  helper_method :answer
  
  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:name, :reward_file])
  end

  def find_subscription
    @subscription = current_user.subscriptions.find_by(question_id: question) if current_user
  end
end
