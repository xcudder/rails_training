Rails.application.routes.draw do
    root "companies#index"

    resources :companies
    resources :games
    resources :books
end
