Myflix::Application.routes.draw do
	root to: 'pages#front'
	get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :relationships, only: [:create, :destroy]

  resources :videos do
    resources :reviews, only: [:create, :edit, :update]
  end
  resources :categories
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :invitations, only: [:new, :create]

  post 'update_queue', to: 'queue_items#update_queue' do
  end
end
