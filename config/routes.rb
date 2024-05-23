Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'client/sessions', registrations: 'client/registrations' }
    namespace :client, path: '' do
      resource 'profile'
      resources 'lottery'
      resources 'addresses'
      resources 'tickets', only: [:create]
      resources 'invitations' do
        get 'generate_qr_code', on: :collection
      end
    end
    root 'client/homepage#index', as: 'client_root'
  end

  constraints(AdminDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'admin/sessions' }, as: :admin
    root 'admin/homepage#index', as: 'admin_root'
    namespace :admin, path: '' do
      resources 'tickets', only: [:index]
      resource 'profile'
      resources :items do
        member do
          post :start
          post :pause
          post :end
          post :cancel
        end
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :regions, only: [] do
        get 'provinces', to: 'regions#provinces'
      end

      resources :provinces, only: [] do
        get 'cities', to: 'provinces#cities'
      end

      resources :cities, only: [] do
        get 'barangays', to: 'cities#barangays'
      end
    end
  end
end


