require 'rails_helper'

RSpec.describe NewAnswerDigestService do
  let(:users) { create_list :user, 2 }
  let(:question) { create :question, user: users.first }
  let(:answer) { create :answer, question: question, user: users.last }

  it 'sends notification only to subscribed user of question' do
    expect(NewAnswerDigestMailer).to receive(:notify).with(users.first, answer).and_call_original
    subject.send_notify(answer)
  end

  it 'not subscribed user will not receive notification' do
    expect(NewAnswerDigestMailer).to_not receive(:notify).with(users.last, answer)
    subject.send_notify(answer)
  end
end
