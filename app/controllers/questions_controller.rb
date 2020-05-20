class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  authorize_resource
  include Voted
  after_action :publish_question, only: [:create]

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
    #я не пониманию, почему без этого не работает. Т.к. вначале файла уже стоит authorize_resource
    authorize! :destroy, question
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
end
