Rails.application.routes.draw do
  namespace :file_systems do
    get "directories/show"
  end
  mount MissionControl::Jobs::Engine, at: "/admin/jobs"

  root "app/welcome#index"

  resource :first_run, only: [ :show, :create ]

  resource :session
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
  resources :archives, only: [ :index, :new, :create, :edit, :update, :destroy ] do
    post :access, on: :member
    post :exit, on: :member
  end

  resources :file_systems, only: [ :show ] do
    scope module: :file_systems do
      resources :files, only: [ :show, :create, :edit, :update, :destroy ] do
        get :attachment, on: :member
        get :download, on: :member
      end

      resources :directories, only: [ :show ]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
