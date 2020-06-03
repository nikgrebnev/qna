class NewAnswerDigestMailer < ApplicationMailer
  def notify(user, answer)
    @user = user
    @answer = answer

    mail to: @user.email,
      subject: "New answer for question #{@answer.question.title}"
  end
end
