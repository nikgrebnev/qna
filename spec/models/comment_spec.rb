require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should validate_presence_of :body }

  describe 'default scope' do
    let!(:comment1) { create(:comment) }
    let!(:comment2) { create(:comment) }

    it 'orders by created_at desc' do
      expect(Comment.all.to_a).to eq [comment2, comment1]
    end
  end
end
