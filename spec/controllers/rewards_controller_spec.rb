require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:reward) { create(:reward, question: question, user: user) }

  describe 'GET #index' do

    before do
      login(user)
      get :index
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

end
