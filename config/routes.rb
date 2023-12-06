Rails.application.routes.draw do
  resources :reviews

  root "movies#index"

  resources :movies

  # Above resources conventional shortcut, removes the need to create
  # individual routes, as they are shown below
  
  # get "movies" => "movies#index"
  # get "movies/:id" => "movies#show", as: "movie"
  # get "movies/:id/edit" => "movies#edit", as: "edit_movie"
  # patch "movies/:id/" => "movies#update"

end
