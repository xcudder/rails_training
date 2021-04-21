Rails.application.routes.draw do
    root "companies#index"

    resources :companies
    resources :games
    resources :books

    namespace :api, defaults: {format: :json}  do
        resources :companies
        resources :games
        resources :books
    end
end
