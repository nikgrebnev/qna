class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable

    authorize! :destroy, link

    link.destroy
    message = { notice: 'Your link successfully deleted' }

    if resource.is_a?(Question)
      redirect_to resource, message
    else
      redirect_to resource.question, message
    end
  end
end
