require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls ServiceReputation#calculate' do
    expect(ServiceReputation).to receive(:calculate).with(question)
    ReputationJob.perform_now(question)
  end
end
