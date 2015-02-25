Myflix::Application.routes.draw do
	root to: 'pages#front'
	get '/home', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'

  resources :videos
  resources :categories
  resources :users, only: [:new, :create]
end
