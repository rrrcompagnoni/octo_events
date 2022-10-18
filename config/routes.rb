Rails.application.routes.draw do
  namespace :issues do
    resources :events, only: [:create]
  end
end
