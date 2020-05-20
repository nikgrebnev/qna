class CommentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create


  def create
    comment.user = current_user
    comment.save
  end

  private

  def comment
    @comment ||= params[:id] ? Comment.find(params[:id]) : @resource.comments.new(comment_params)
  end

  def find_resource
    if params[:answer_id]
      @resource = Answer.find(params[:answer_id])
    else
      @resource = Question.find(params[:question_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if comment.errors.any?

    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast(
        "question_#{question_id}",
        { event: 'new_comment',
          comment: comment,
          resource_type: comment.commentable_type.downcase,
          resource_id: comment.commentable_id
        }
    )
  end

end
