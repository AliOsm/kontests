Rails.application.routes.draw do
  get 'suggests/index'
  get 'suggests/create'
	root 'pages#home'
	
  get 'pages/home'
  
  resources :suggests, only: [:index, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
