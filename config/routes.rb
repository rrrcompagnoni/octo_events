Rails.application.routes.draw do
  namespace :issues do
    resources :events, only: [:create]

    get ':issue_number/events', to: 'events#index'
  end
end
