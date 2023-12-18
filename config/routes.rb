Rails.application.routes.draw do
  resources :users

  root "movies#index"

  resources :movies do
    resources :reviews
  end

  # Above resources conventional shortcut, removes the need to create
  # individual routes, as they are shown below
  
  # get "movies" => "movies#index"
  # get "movies/:id" => "movies#show", as: "movie"
  # get "movies/:id/edit" => "movies#edit", as: "edit_movie"
  # patch "movies/:id/" => "movies#update"

end
