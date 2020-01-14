class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = current_user.questions.new
  end

  def edit
  end

  def create
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
  end

  def destroy
    if current_user&.author?(question)
      question.destroy
      flash[:notice] = 'Deleted successfully'
    else
      flash[:alert] = "You can not delete"
    end
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : current_user.questions.new(question_params)
  end
  helper_method :question

  def answer
    @answer ||= question.answers.new(user: current_user)
  end
  helper_method :answer
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
