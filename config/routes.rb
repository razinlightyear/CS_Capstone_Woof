Rails.application.routes.draw do
  resources :events, except: :show do
    collection do
      post :create_lost_dog
    end
  end
  get ':events/:user_id', controller: :events, action: :show  # => 'events#show'
  resources :colors
  resources :weights
  resources :breeds
  resources :pets
  resources :groups
  resources :users
  resources :events
  get 'users/profile/:user_id', controller: :users, action: :profile, as: :user_profile
  root 'home#index' # create a homepage that doesn't belong to a model
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end