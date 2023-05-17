Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, as: 'client', controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '/' do
      resource :profile, only: [:show, :edit, :update]
      resources :invite, only: [:index]
      resources :user_address, path: 'address'
      resources :lottery, only: [:index, :show, :create]
      resources :orders do
        post :cancel
      end
      resources :shops do
        post :submit, :pay
      end
      resources :winners do
        post :claim, :share
      end
      resources :shares
      resources :claims
    end
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, as: 'admin', controllers: { sessions: 'admin/sessions' }
    namespace :admin do
      resources :users
      resources :items do
        post :start, :pause, :end, :cancel
      end
      resources :categories, except: :show
      resources :bets, only: [:index]
      resources :winners do
        post :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers
      resources :orders do
        post :submit, :pay, :cancel
      end
    end
  end

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end
      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end
      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end
      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end
end
