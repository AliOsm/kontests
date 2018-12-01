Rails.application.routes.draw do
	root 'pages#home'
	
  get '/home', to: 'pages#home'
  get '/api', to: 'pages#api'
  get '/about', to: 'pages#about'
  
  resources :suggests, only: [:index, :create]
  resources :joins, only: [:index, :create]

  get 'api/v1/all'
  get 'api/v1/codeforces'
  get 'api/v1/codeforces_gym'
  get 'api/v1/cs_academy'
  get 'api/v1/at_coder'
  get 'api/v1/code_chef'
  get 'api/v1/hacker_earth'
  get 'api/v1/a2oj'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
