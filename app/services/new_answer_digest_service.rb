class NewAnswerDigestService
  def send_notify(answer)
    users = User.joins(:subscriptions).where(subscriptions: {question_id: answer.question})

    users.find_each do |user|
      NewAnswerDigestMailer.notify(user, answer).try(:deliver_later)
    end
  end
end
