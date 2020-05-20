module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: [:voteup, :votedown, :votecancel]
  end

  def voteup
    authorize! :vote, @resource
    if @resource.can_vote?(current_user)
      @resource.vote!(current_user, 1)
      send_json('allow')
    end
  end

  def votedown
    authorize! :vote, @resource
    if @resource.can_vote?(current_user)
      @resource.vote!(current_user, -1)
      send_json('allow')
    end
  end

  def votecancel
    authorize! :vote, @resource
    if @resource.can_cancel?(current_user)
      @resource.vote_cancel(current_user)
      send_json('disable')
    end
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def send_json(show_cancel_link)
    render json: { id: @resource.id, counter: @resource.counter, votes_rate: @resource.votes_rate, show_cancel_link: show_cancel_link }
  end
end
