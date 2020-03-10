class QuestionChannel < ApplicationCable::Channel
  def subscribed
  end

  def follow(data)
    stream_from "question_#{data['id']}"
  end
end
