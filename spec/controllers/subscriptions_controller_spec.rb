require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    let(:request_subscription) { post :create, params: { question_id: question.id }, format: :js }

    context 'user not subscribed' do
      before { login(user) }

      it 'change subscriptions' do
        expect { request_subscription }.to change(user.subscriptions, :count).by(1)
      end

      it 'check return' do
        request_subscription

        expect(response).to render_template :create
      end
    end

    context 'user subscribed' do
      before { login(author) }

      it 'can not add duplicate subscriptions' do
        expect { request_subscription }.to change(author.subscriptions, :count).by(0)
      end

      it 'check return' do
        request_subscription

        expect(response).to be_successful
      end
    end

    context 'guest' do
      it 'not change resource' do
        expect { request_subscription }.to_not change(Subscription, :count)
      end

      it 'check return' do
        request_subscription

        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let(:request_subscription) { delete :destroy, params: { id: subscription.id }, format: :js }

    context 'user is owner of subscription' do
      before { login(user) }

      it 'delete subscriptions' do
        expect { request_subscription }.to change(user.subscriptions, :count).by(-1)
      end

      it 'check return' do
        request_subscription

        expect(response).to render_template :destroy
      end
    end

    context 'user is not owner of subscription' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'can not delete subscriptions' do
        expect { request_subscription }.to_not change(user.subscriptions, :count)
      end

      it 'check return' do
        request_subscription

        expect(response).to be_successful
        expect(response).to render_template :destroy
      end
    end

    context 'guest' do
      it 'not change resource' do
        expect { request_subscription }.to_not change(Subscription, :count)
      end

      it 'check return' do
        request_subscription

        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
  end
end
