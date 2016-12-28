require 'api_version'

Rails.application.routes.draw do
  devise_for :users
  # mount API::Base, at: '/'
  # mount GrapeSwaggerRails::Engine => '/docs'
  #
  # get 'secure' => 'secure#index'
  # get 'secure/logout' => 'secure#logout'
  get '/' => 'static_pages#index'
  if ENV['API_SUBDOMAIN']
    subdomain_constraint = { subdomain: ENV['API_SUBDOMAIN'].split(',') }
  else
    subdomain_constraint = {}
  end

  namespace :api, path: '/', constraints: subdomain_constraint do
    scope defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiVersion.new('v1', true) do

        resources :import_csv, only: [:create], controller: :import_csv
        resources :user, only: [:create, :show], controller: :user
        namespace :users do
          resource :profile, only: [:show, :update], controller: :profile
          resources :messages, only: [:create, :index, :show, :destroy]
          resource :sessions, only: [:create]
          resources :vote, only: [:create, :update, :destroy, :index], controller: :vote
          resource :follows, only: [:create], controller: :follows
        end
        resources :votes, only: [:index]

        namespace :votes do
          resource :participate, only: [:create, :update, :destroy], controller: :participate
          resources :details, only: [:show]
          resources :categories, only: [:index, :create]
        end

        namespace :utilities do
          resource :locations, only: [:show]
          resources :degrees, only: [:index]
        end

        namespace :analyzes do
          resources :votes, only: [:show]
          resources :vote_options, only: [:show]
          resources :vote_statistics, only: [:show]
          resources :overviews, only: [:show]
          get 'dashboard_chart' => 'dashboard_page#chart_stats'
          get 'dashboard_top' => 'dashboard_page#top_page'
        end

        namespace :files do
          resources :avatars, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
          resources :votes, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
          resources :vote_options, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
          resources :upload, only: [:create] do
            member do
              get ':file(.:ext)', action: 'get'
            end
          end
        end

      end
    end
  end

end
