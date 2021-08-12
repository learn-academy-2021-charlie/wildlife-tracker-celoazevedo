Rails.application.routes.draw do
  resources :animals
  # resources :animals   <--> this will replace all of the routes that we initially had to write out. Thanks to the rails generate resourses command.
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
