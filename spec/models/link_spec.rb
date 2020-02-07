require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }


  describe 'test gist rules' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, linkable: question) }
    let(:link_gist) { create(:link, :gist_url, linkable: question) }

    it 'link is no gist' do
      expect(link).to_not be_gist
    end

    it 'gist is gist' do
      expect(link_gist).to be_gist
    end

    it 'gist_content returns gist' do
      expect(link_gist.gist_content).to eq "puts 'Hello, world!\""
    end
  end

end
