require 'rails_helper'

RSpec.describe Question, type: :model do
  it_should_behave_like "links"
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_one :reward }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :counter }


  it_should_behave_like 'Model Vote' do
    let(:question_author) { create(:user) }
    let(:question) { create(:question, user: question_author) }

    let(:resource) { question }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
