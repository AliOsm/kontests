Rails.application.routes.draw do
	root 'pages#home'
	
  get 'pages/home'
  get 'pages/about'
  
  resources :suggests, only: [:index, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
