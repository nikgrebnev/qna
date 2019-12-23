class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
  end

  def new
#    @question = Question.new
  end

  def edit
  end

  def create
    if question.save
      redirect_to question
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
    question.destroy
    redirect_to questions_path
  end
  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new(question_params)
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end