require 'resque/server'
Rails.application.routes.draw do
  resources :nudges
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions"
  }
  get '/users/find', controller: :users, action: :find
  get 'update_password', controller: :users, action: :update_password
  patch 'update_password', controller: :users, action: :update_password
  patch 'new_invited_user', controller: :users, action: :new_invited_user
  get 'new_invited_user', controller: :users, action: :new_invited_user
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
    member do
      get 'image_modal'
    end
  end
  resources :groups do
    # group_feeding_histories GET    /groups/:group_id/feeding_histories(.:format) feeding_histories#index
    resources :feeding_histories, only: :index
    member do
      get 'chat'
    end
  end

  # Added by Paarth Lakhani for the group chatting. Ask Andrew about the chat
  get 'groups_allChats', controller: :groups, action: :groups_allChats

  resources :events do
    member do
      get 'chat'
    end
  end

  get '/events_map', controller: :events, action: :events_map
  post '/events/filter_events', controller: :events, action: :filter_events
 # resources :lost_dogs # reaplace :create_lost_dogs
  # resources :found_dogs
  resources :feeding_histories
  resources :walking_partners
  resources :ios_sessions, only: [:create]
  resources :group_invites
  get 'users/group_invites/accept', controller: :group_invites, action: :accept
  get 'users/group_invites/decline', controller: :group_invites, action: :decline
  get 'users/group_invites/accept_new', controller: :group_invites, action: :accept_new

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

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  get '/group_nudge', controller: :nudges, action: :group_nudge 
  resources :users do 
    resources :chats, only: [:index, :show, :create]
  end
  resources :messages, only:[:create]

  controller :lost_dogs do
    get 'lost_dogs/new' => :new
    post 'lost_dogs/create' => :create
    get 'lost_dogs/get_pets' => :get_pets
    post 'lost_dogs/update_lost_address' => :update_lost_address
    get 'lost_dogs/:id' => :show, as: :lost_dog
    get 'lost_dogs/:id/edit' => :edit, as: :edit_lost_dog
    put 'lost_dogs/:id' => :update
    patch 'lost_dogs/:id' => :update
    delete 'lost_dogs/:id' => :destroy
  end
  
  controller :found_dogs do
    get 'found_dogs/new' => :new
    post 'found_dogs/create' => :create
    post 'found_dogs/update_lost_address' => :update_lost_address
    get  'found_dogs/:id' => :show, as: :found_dog
    get 'found_dogs/:id/edit' => :edit, as: :edit_found_dog
    put 'found_dogs/:id' => :update
    patch 'found_dogs/:id' => :update
    delete 'found_dogs/:id' => :destroy
  end

  controller :post_events do
    get 'post_events/new' => :new
    post 'post_events/create' => :create
    post 'post_events/update_lost_address' => :update_lost_address
    get  'post_events/:id' => :show, as: :post_event
    get 'post_events/:id/edit' => :edit, as: :edit_post_event
    put 'post_events/:id' => :update
    patch 'post_events/:id' => :update
    delete 'post_events/:id' => :destroy
  end

  resources :feedbacks, only: [:create]

  #get 'lost_dogs/new', controller: :lost_dogs, action: :new
  #post 'lost_dogs/create', controller: :lost_dogs, action: :create

  mount StatusPage::Engine, at: '/'  # GET /status
  mount Resque::Server, at: 'resque' # GET /resque to see a resque overview
end
