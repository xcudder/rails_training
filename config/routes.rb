Rails.application.routes.draw do
    root "companies#index"

    resources :companies
    resources :games
    resources :books

    namespace :api, defaults: {format: :json}  do
        resources :companies
        resources :games
        resources :books

        resources :tag_types, only: :index

        resources :employees do
            member do
                put 'tags', to: 'employees#associate_tags'
                get 'tags', to: 'employees#tags'
            end
        end

        resources :tags do
            member do
                put 'employees', to: 'tags#associate_employees'
                get 'employees', to: 'tags#employees'
            end
        end
    end
end
