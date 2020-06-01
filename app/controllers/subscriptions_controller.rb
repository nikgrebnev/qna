class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    unless current_user.subscribed?(question)
      @subscription = current_user.subscribe!(question)

      flash[:notice] = 'Subscribed successfully'
    else
      flash[:notice] = 'Already subscribed'
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    if current_user.subscribed?(@subscription.question)
      @subscription.destroy
      flash[:notice] = 'Unsubscribed successfully'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
