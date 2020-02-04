class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    link = Link.find(params[:id])
    resource = link.linkable

    if current_user.author?(resource)
      link.destroy
      message = { notice: 'Your link successfully deleted' }
    else
      message = { alert: 'You can not delete' }
    end

    if resource.is_a?(Question)
      redirect_to resource, message
    else
      redirect_to resource.question, message
    end
  end
end
