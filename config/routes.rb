Rails.application.routes.draw do
  resources :pets
  resources :groups
  resources :users
  
  root 'home#index' # create a homepage that doeasn't belong to a view
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
