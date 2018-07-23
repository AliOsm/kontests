Rails.application.routes.draw do
	root 'pages#home'
	
  get '/home', to: 'pages#home'
  get '/about', to: 'pages#about'
  
  resources :suggests, only: [:index, :create]
  resources :joins, only: [:index, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
