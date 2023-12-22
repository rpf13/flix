Rails.application.routes.draw do

  root "movies#index"

  resources :movies do
    resources :reviews
  end

  resources :users

  # custom route to use /signup in addition to /users/new
  get "signup" => "users#new"

  # the session resouce will limit to only have routes for the
  # specified actions, since we don't need edit, ...
  resource :session, only: [:new, :create, :destroy]

  # custom route to use /signin in addition to /session/new
  get "signin" => "sessions#new"



  # Above resources conventional shortcut, removes the need to create
  # individual routes, as they are shown below
  
  # get "movies" => "movies#index"
  # get "movies/:id" => "movies#show", as: "movie"
  # get "movies/:id/edit" => "movies#edit", as: "edit_movie"
  # patch "movies/:id/" => "movies#update"

end
