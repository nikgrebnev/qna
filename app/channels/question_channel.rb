class QuestionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:room].to_i}"

  end
end
