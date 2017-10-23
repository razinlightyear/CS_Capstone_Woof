Rails.application.routes.draw do
  resources :nudges
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  
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
  get '/events_map', controller: :events, action: :events_map
 # resources :lost_dogs # reaplace :create_lost_dogs
  # resources :found_dogs
  resources :feeding_histories
  resources :walking_partners
  resources :ios_sessions, only: [:create]

  delete '/ios/sign_out', to: 'ios_sessions#destroy'
  post '/ios/sign_up', to: 'ios_sessions#new'

  get '/login', controller: :home, action: :login # if you are not signed in or token expires or this is the main woof homepage
  post 'login', controller: :home, action: :create # when user enters credentials into the homepage and click 'Sign In', a post request sends all the credentials to this action
  get 'groups_pets', controller: :users, action: :groups_pets # users access their groups and pets.

  # ask users about this
  #resources :users do
  #  member do
  #    get 'profile' => :profile
  #    get 'profile' => :profile_edit
  #  end
  #end

  # When you submit this, then all parameters get passed.
  get 'profile', controller: :users, action: :profile
  get 'profile/edit', controller: :users, action: :profile_edit
  post 'profile/update', controller: :users, action: :profile_update

  root 'home#index' # create a homepage that doesn't belong to a model. # This is the real homepage
  # controller of home - index rediret to the events page.

  get 'home/sign_out_profile'


  get '/group_nudge', controller: :nudges, action: :group_nudge 

  controller :lost_dogs do
    get 'lost_dogs/new' => :new
    post 'lost_dogs/create' => :create
    get 'lost_dogs/get_pets' => :get_pets
    get 'lost_dogs/:id' => :show, as: :lost_dog
    get 'lost_dogs/:id/edit' => :edit, as: :edit_lost_dog
    put 'lost_dogs/:id' => :update
    patch 'lost_dogs/:id' => :update
    delete 'lost_dogs/:id' => :destroy
  end
  
  controller :found_dogs do
    get 'found_dogs/new' => :new
    post 'found_dogs/create' => :create
    get  'found_dogs/:id' => :show, as: :found_dog
    get 'found_dogs/:id/edit' => :edit, as: :edit_found_dog
    put 'found_dogs/:id' => :update
    patch 'found_dogs/:id' => :update
    delete 'found_dogs/:id' => :destroy
  end

  #get 'lost_dogs/new', controller: :lost_dogs, action: :new
  #post 'lost_dogs/create', controller: :lost_dogs, action: :create

  mount StatusPage::Engine, at: '/' # GET /status
end
