Rails.application.routes.draw do
  resources :around_mes, except: :show
  resources :colors
  resources :weights
  resources :breeds
  resources :pets
  resources :groups
  resources :users
  get ':around_mes/:user_id', controller: :around_mes, action: :show  # => 'around_mes#show'
  root 'home#index' # create a homepage that doeasn't belong to a model
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
