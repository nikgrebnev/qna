class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment = ActiveStorage::Attachment.find(params[:id])
    resource = attachment.record

    authorize! :destroy, attachment

    attachment.purge
    message = { notice: 'Your file successfully deleted' }

    if resource.is_a?(Question)
      redirect_to resource, message
    else
      redirect_to resource.question, message
    end
  end
end
