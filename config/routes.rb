Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, as: 'client', controllers: {sessions: 'client/sessions', registrations: 'client/registrations'}
    namespace :client, path: '/' do
      resource :profile, only: [:show, :edit, :update]
      resources :invite, only: [:index]
    end
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, as: 'admin', controllers: {sessions: 'admin/sessions'}
    namespace :admin do
      resources :users
    end
  end
  root 'home#index'
end
