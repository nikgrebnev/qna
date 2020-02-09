Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  resources :questions do
    resources :answers, shallow: true do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :rewards, only: :index

  root to: "questions#index"
end
