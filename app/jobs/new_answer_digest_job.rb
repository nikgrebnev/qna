class NewAnswerDigestJob < ApplicationJob
  queue_as :default

  def perform(object)
    NewAnswerDigestService.new.send_notify(object)
  end
end
