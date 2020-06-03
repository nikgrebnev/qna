require "rails_helper"

RSpec.describe NewAnswerDigestMailer, type: :mailer do
  describe 'New answer digest' do
    let(:users) { create_list :user, 3 }
    let(:user) { users.first }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: users.last }
    let(:mail) { NewAnswerDigestMailer.notify(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New answer for question #{answer.question.title}")
      expect(mail.to).to eq [question.user.email]
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
