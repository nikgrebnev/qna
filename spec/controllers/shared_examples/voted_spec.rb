RSpec.shared_examples "voted" do

  describe 'POST #voteup' do
    context 'resource author' do
      before { login(author) }

      it 'not change resource' do
        expect { post :voteup, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :voteup, params: { id: resource.id }, format: :js
        expect(response.body).to eq ''
      end
    end

    context 'other user' do
      before { login(user) }

      it 'change resource votes' do
        expect { post :voteup, params: { id: resource.id }, format: :js }.to change(resource.votes, :count).by(1)
      end

      it 'change resource.votes_rate' do
        post :voteup, params: { id: resource.id }, format: :js
        resource.reload
        expect(resource.votes_rate).to eq 1
      end

      it 'check return' do
        post :voteup, params: { id: resource.id }, format: :js
        parsed_body = JSON(response.body)
        expect(parsed_body["id"]).to eq resource.id
        expect(parsed_body["votes_rate"]).to eq 1
        expect(parsed_body["show_cancel_link"]).to eq 'allow'
      end
    end

    context 'guest' do
      it 'not change resource' do
        expect { post :voteup, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :voteup, params: { id: resource.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'POST #votedown' do
    context 'resource author' do
      before { login(author) }

      it 'not change resource' do
        expect { post :votedown, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :votedown, params: { id: resource.id }, format: :js
        expect(response.body).to eq ''
      end
    end

    context 'other user' do
      before { login(user) }

      it 'change resource votes' do
        expect { post :votedown, params: { id: resource.id }, format: :js }.to change(resource.votes, :count).by(1)
      end

      it 'change resource.votes_rate' do
        post :votedown, params: { id: resource.id }, format: :js
        resource.reload
        expect(resource.votes_rate).to eq -1
      end

      it 'check return' do
        post :votedown, params: { id: resource.id }, format: :js
        parsed_body = JSON(response.body)
        expect(parsed_body["id"]).to eq resource.id
        expect(parsed_body["votes_rate"]).to eq -1
        expect(parsed_body["show_cancel_link"]).to eq 'allow'
      end
    end

    context 'guest' do
      it 'not change resource' do
        expect { post :votedown, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :votedown, params: { id: resource.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'POST #votecancel' do
    context 'resource author' do
      before { login(author) }

      it 'not change resource' do
        expect { post :votecancel, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :votecancel, params: { id: resource.id }, format: :js
        expect(response.body).to eq ''
      end
    end

    context 'other user, not voted resource' do
      before { login(user) }

      it 'not change resource' do
        expect { post :votecancel, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :votecancel, params: { id: resource.id }, format: :js
        expect(response.body).to eq ''
      end
    end

    context 'other user, voted +1 resource' do
      before do
        login(user)
        post :voteup, params: { id: resource.id }, format: :js
      end

      it 'change resource' do
        expect { post :votecancel, params: { id: resource.id }, format: :js }.to change(resource.votes, :count).by(-1)
      end

      it 'check return' do
        post :votecancel, params: { id: resource.id }, format: :js
        parsed_body = JSON(response.body)
        expect(parsed_body["id"]).to eq resource.id
        expect(parsed_body["votes_rate"]).to eq 0
        expect(parsed_body["show_cancel_link"]).to eq 'disable'
      end
    end

    context 'other user, voted -1 resource' do
      before do
        login(user)
        post :votedown, params: { id: resource.id }, format: :js
      end

      it 'change resource' do
        expect { post :votecancel, params: { id: resource.id }, format: :js }.to change(resource.votes, :count).by(-1)
      end

      it 'check return' do
        post :votecancel, params: { id: resource.id }, format: :js
        parsed_body = JSON(response.body)
        expect(parsed_body["id"]).to eq resource.id
        expect(parsed_body["votes_rate"]).to eq 0
        expect(parsed_body["show_cancel_link"]).to eq 'disable'
      end
    end

    context 'guest' do
      it 'not change resource' do
        expect { post :votecancel, params: { id: resource.id }, format: :js }.to_not change(resource.votes, :count)
      end

      it 'check return' do
        post :votecancel, params: { id: resource.id }, format: :js
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
end

