Rails.application.routes.draw do
  resources :around_me, except: :show
  resources :colors
  resources :weights
  resources :breeds
  resources :pets
  resources :groups
  resources :users
  get ':around_me/:user_id', controller: :around_me, action: :show  # => 'around_me#show'
  root 'home#index' # create a homepage that doeasn't belong to a model
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
