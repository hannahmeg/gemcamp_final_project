Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'client/registrations' }

  constraints(ClientDomainConstraint.new) do
    devise_scope :user do
      get 'client/sign_in', to: 'client/sessions#new'
      post 'client/sign_in', to: 'client/sessions#create'
      get 'sign_up', to: 'client/registrations#new'
      post 'sign_up', to: 'client/registrations#create'

    end
    get 'homepage', to: 'client#homepage'
    get 'menu', to: 'client#menu'
    get 'me', to: 'client#me'
    namespace :client do
      resource 'profile'
    end
    root 'client#index', as: 'client_root'
  end

  constraints(AdminDomainConstraint.new) do
    devise_scope :user do
      get 'admin/sign_in', to: 'admin/sessions#new', as: 'new_admin_session'
      post 'admin/sign_in', to: 'admin/sessions#create'
    end
    root 'admin#index', as: 'admin_root'
  end
end

