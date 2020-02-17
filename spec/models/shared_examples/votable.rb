RSpec.shared_examples "Model Vote" do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }

  let(:user1) { create(:user) }

  describe 'test can_vote?' do
    it 'can_vote? from author' do
      expect(resource.can_vote?(resource.user)).to be_falsey
    end

    it 'can_vote? from author - 1' do
      #is_expected.to_not be_can_vote(resource.user)
      expect(resource).to be_can_vote(resource.user)
      #expect(resource.can_vote?(resource.user)).to be_falsey
    end

    it 'can_vote? from not author and not voted resource' do
      expect(resource.can_vote?(user1)).to be_truthy
    end

    it 'can_vote? from not author and voted +1 resource' do
      resource.vote(user1,1)
      expect(resource.can_vote?(user1)).to be_falsey
    end

    it 'can_vote? from not author and voted -1 resource' do
      resource.vote(user1,-1)
      expect(resource.can_vote?(user1)).to be_falsey
        # expect(resource).to be_can_vote(user1)
           #is_expected.to_not be_resource.can_vote(user1)
    end
  end

  describe 'test can_cancel?' do
    it 'can_cancel? from author' do
      expect(resource.can_cancel?(resource.user)).to be_falsey
    end

    it 'can_cancel? from not author and not voted resource' do
      expect(resource.can_cancel?(user1)).to be_falsey
    end

    it 'can_cancel? from not author and voted +1 resource' do
      resource.vote(user1,1)
      expect(resource.can_cancel?(user1)).to be_truthy
    end

    it 'can_vote? from not author and voted -1 resource' do
      resource.vote(user1,-1)
      expect(resource.can_cancel?(user1)).to be_truthy
    end
  end

  describe 'test vote function, votes count' do
    it 'vote from author' do
      expect{ resource.vote(resource.user,1) }.to_not change(resource.votes, :count)
    end

    it 'vote +1 from not author and not voted resource' do
      expect{ resource.vote(user1,+1) }.to change(resource.votes, :count).by(1)
    end

    it 'vote -1 from not author and not voted resource' do
      expect{ resource.vote(user1,-1) }.to change(resource.votes, :count).by(1)
    end

    it 'vote from not author and voted resource' do
      resource.vote(user1,1)
      expect{ resource.vote(resource.user,+1) }.to_not change(resource.votes, :count)
    end

    it 'vote from not author, test user' do
      resource.vote(user1,1)
      expect(resource.votes.first.user).to eq user1
    end
  end

  describe 'test vote_cancel function, votes count' do
    it 'voted resource from not author' do
      resource.vote(user1,1)
      expect{ resource.vote_cancel(user1) }.to change(resource.votes, :count).by(-1)
    end
  end

  describe 'test vote function, resource.counter' do
    let(:user2) { create(:user) }

    it 'vote from author' do
      resource.vote(resource.user,1)
      expect(resource.counter).to eq 0
    end

    it 'vote +1 from not author and not voted resource' do
      resource.vote(user1,1)
      expect(resource.counter).to eq 1
    end

    it 'vote -1 from not author and not voted resource' do
      resource.vote(user1,-1)
      expect(resource.counter).to eq -1
    end

    it 'multiple votes from not author' do
      resource.vote(user1,+1)
      expect(resource.counter).to eq 1
      resource.vote(user1,+1)
      expect(resource.counter).to eq 1
      resource.vote(user1,-1)
      expect(resource.counter).to eq 1

      resource.vote_cancel(user1)
      expect(resource.counter).to eq 0

      resource.vote(user1,-1)
      expect(resource.counter).to eq -1
      resource.vote(user1,-1)
      expect(resource.counter).to eq -1
      resource.vote(user1,+1)
      expect(resource.counter).to eq -1

      resource.vote_cancel(user1)
      expect(resource.counter).to eq 0
    end

    it 'multiple votes from several users' do
      resource.vote(user1,+1)
      expect(resource.counter).to eq 1
      resource.vote(user2,+1)
      expect(resource.counter).to eq 2

      resource.vote_cancel(user1)
      expect(resource.counter).to eq 1
      resource.vote_cancel(user2)
      expect(resource.counter).to eq 0

      resource.vote(user1,-1)
      expect(resource.counter).to eq -1
      resource.vote(user2,-1)
      expect(resource.counter).to eq -2

      resource.vote_cancel(user1)
      expect(resource.counter).to eq -1
      resource.vote_cancel(user2)
      expect(resource.counter).to eq 0

      resource.vote(user1,-1)
      resource.vote(user2,+1)
      expect(resource.counter).to eq 0
    end
  end

  describe 'test votes_rate function' do
    let(:user2) { create(:user) }

    it 'vote from author' do
      resource.vote(resource.user,1)
      expect(resource.votes_rate).to eq 0
    end

    it 'vote +1 from not author and not voted resource' do
      resource.vote(user1,1)
      expect(resource.votes_rate).to eq 1
    end

    it 'vote -1 from not author and not voted resource' do
      resource.vote(user1,-1)
      expect(resource.votes_rate).to eq -1
    end

    it 'multiple votes from not author' do
      resource.vote(user1,+1)
      expect(resource.votes_rate).to eq 1
      resource.vote(user1,+1)
      expect(resource.votes_rate).to eq 1
      resource.vote(user1,-1)
      expect(resource.votes_rate).to eq 1

      resource.vote_cancel(user1)
      expect(resource.votes_rate).to eq 0

      resource.vote(user1,-1)
      expect(resource.votes_rate).to eq -1
      resource.vote(user1,-1)
      expect(resource.votes_rate).to eq -1
      resource.vote(user1,+1)
      expect(resource.votes_rate).to eq -1

      resource.vote_cancel(user1)
      expect(resource.votes_rate).to eq 0
    end

    it 'multiple votes from several users' do
      resource.vote(user1,+1)
      expect(resource.votes_rate).to eq 1
      resource.vote(user2,+1)
      expect(resource.votes_rate).to eq 2

      resource.vote_cancel(user1)
      expect(resource.votes_rate).to eq 1
      resource.vote_cancel(user2)
      expect(resource.votes_rate).to eq 0

      resource.vote(user1,-1)
      expect(resource.votes_rate).to eq -1
      resource.vote(user2,-1)
      expect(resource.votes_rate).to eq -2

      resource.vote_cancel(user1)
      expect(resource.votes_rate).to eq -1
      resource.vote_cancel(user2)
      expect(resource.votes_rate).to eq 0

      resource.vote(user1,-1)
      resource.vote(user2,+1)
      expect(resource.votes_rate).to eq 0
    end
  end
end
