RSpec.shared_examples "Model Vote" do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }

  let(:user1) { create(:user) }

  describe 'test can_vote?' do
    it 'can_vote? from not author and not voted resource' do
      expect(resource).to be_can_vote(user1)
    end

    it 'can_vote? from not author and voted +1 resource' do
      resource.vote!(user1,1)
      expect(resource).to_not be_can_vote(user1)
    end

    it 'can_vote? from not author and voted -1 resource' do
      resource.vote!(user1,-1)
      expect(resource).to_not be_can_vote(user1)
    end
  end

  describe 'test can_cancel?' do
    it 'can_cancel? from not author and not voted resource' do
      expect(resource).to_not be_can_cancel(user1)
    end

    it 'can_cancel? from not author and voted +1 resource' do
      resource.vote!(user1,1)
      expect(resource).to be_can_cancel(user1)
    end

    it 'can_vote? from not author and voted -1 resource' do
      resource.vote!(user1,-1)
      expect(resource).to be_can_cancel(user1)
    end
  end

  describe 'test vote function, votes count' do
    it 'vote from author' do
      expect { resource.vote!(resource.user,1) }.to raise_error(ActiveRecord::RecordInvalid ,'Validation failed: Author can not vote for his resource')
    end

    it 'vote +1 from not author and not voted resource' do
      expect{ resource.vote!(user1,+1) }.to change(resource.votes, :count).by(1)
    end

    it 'vote -1 from not author and not voted resource' do
      expect{ resource.vote!(user1,-1) }.to change(resource.votes, :count).by(1)
    end

    it 'vote from not author and voted resource' do
      resource.vote!(user1,1)
      expect { resource.vote!(resource.user,+1) }.to raise_error(ActiveRecord::RecordInvalid ,'Validation failed: Author can not vote for his resource')
    end

    it 'vote from not author, test user' do
      resource.vote!(user1,1)
      expect(resource.votes.first.user).to eq user1
    end
  end

  describe 'test vote_cancel function, votes count' do
    let!(:vote1) { create(:vote, votable: resource, user: user1) }
    it 'voted resource from not author' do
      expect{ resource.vote_cancel(user1) }.to change(resource.votes, :count).by(-1)
    end
  end

  describe 'test votes_rate function vote +1' do
    let!(:vote1) { create(:vote, votable: resource, value: 1) }
    it 'vote +1' do
      expect(resource.votes_rate).to eq 1
    end
  end

  describe 'test votes_rate function vote -1' do
    let!(:vote1) { create(:vote, votable: resource, value: -1) }
    it 'vote -1' do
      expect(resource.votes_rate).to eq -1
    end
  end

  describe 'test multiple votes_rate function vote +1' do
    let!(:votes) { create_list(:vote, 10, votable: resource, value: 1) }
    it 'votes +10' do
      expect(resource.votes_rate).to eq 10
    end
  end

  describe 'test multiple votes_rate function vote -1' do
    let!(:votes) { create_list(:vote, 10, votable: resource, value: -1) }
    it 'votes -10' do
      expect(resource.votes_rate).to eq -10
    end
  end
end
