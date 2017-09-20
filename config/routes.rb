Rails.application.routes.draw do
  #get 'profile', controller: :users, action: :profile
  resources :users do 
    collection do
      get 'profile'
    end
  end
  # resources creates index, create, new, edit, update, destroy actions by default
  # you can run rails routes to see all of the routing information. For colors you will see
  #     Prefix Verb   URI Pattern                       Controller#Action
  #     colors GET    /colors(.:format)                 colors#index
  #            POST   /colors(.:format)                 colors#create
  #  new_color GET    /colors/new(.:format)             colors#new
  # edit_color GET    /colors/:id/edit(.:format)        colors#edit
  #      color GET    /colors/:id(.:format)             colors#show
  #            PATCH  /colors/:id(.:format)             colors#update
  #            PUT    /colors/:id(.:format)             colors#update
  #            DELETE /colors/:id(.:format)             colors#destroy
  # In the views you can use the prefix to get the paths. Ex color_path(@color), 
  # edit_color_path(@color), new_color_path
  resources :colors do
    collection do
      get 'find'
    end
  end
  resources :weights
  resources :breeds do
    collection do
      get 'find'
    end
  end
  resources :pets do
    resources :feeding_histories, only: :index
  end
  resources :groups do
    # group_feeding_histories GET    /groups/:group_id/feeding_histories(.:format) feeding_histories#index
    resources :feeding_histories, only: :index
  end
  resources :events
  resources :lost_dogs # reaplace :create_lost_dogs
  resources :found_dogs
  resources :feeding_histories
  resources :walking_partners
  get 'login', controller: :home, action: :login
  post 'login', controller: :home, action: :login
  root 'home#index' # create a homepage that doesn't belong to a model
  mount StatusPage::Engine, at: '/' # GET /status
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end