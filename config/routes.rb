# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             path: 'admin',
             path_names: {
               sign_in: '/',
               sign_up: 'new',
               registration: 'register',
             }

  namespace :admin, constraints: { format: 'html' } do
    get 'dashboard', to: 'dashboard#show'
    resources :speakers, only: %i[index new create edit update]
    resources :events, only: %i[index new create edit update destroy]
  end

  get '/sponsor-us', to: redirect('/partner-with-us')

  get '/partner-with-us', to: 'site#sponsor_us'
  get '/meetups', to: 'site#meetups'
  get '/jobs', to: 'site#jobs'
  get '/jobs/authenticate', to: 'site#jobs_authenticate'
  get '/join-us', to: 'site#join_us'
  get '/donate', to: 'site#donate'
  get '/meetups/:year/:month/:day', to: 'site#past_meetup'

  root 'site#home'
  namespace :api, constraints: { format: 'json' } do
    resources :events, only: [:none] do
      collection do
        get 'past'
        get ':year/:month/:day', to: 'events#past_by_month_day'
        get 'upcoming'
      end
    end

    resources :jobs, only: [:index] do
      collection { post 'authenticate' }
    end

    post 'register-user', to: 'registrations#register_user'
  end

  mount ActionCable.server => '/cable'
  resources :grid
end
