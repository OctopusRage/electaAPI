require 'api_version'

Rails.application.routes.draw do
  devise_for :users
  # mount API::Base, at: '/'
  # mount GrapeSwaggerRails::Engine => '/docs'
  #
  # get 'secure' => 'secure#index'
  # get 'secure/logout' => 'secure#logout'

  if ENV['API_SUBDOMAIN']
    subdomain_constraint = { subdomain: ENV['API_SUBDOMAIN'].split(',') }
  else
    subdomain_constraint = {}
  end

  namespace :api, path: '/', constraints: subdomain_constraint do
    scope defaults: { format: 'json' } do
      scope module: :v1, constraints: ApiVersion.new('v1', true) do
        
        resources :user, only: [:create, :show], controller: :user 
        namespace :users do
          resource :profile, only: [:show, :update], controller: :profile 
          resource :sessions, only: [:create]
          resource :vote, only: [:create, :show, :update, :delete], controller: :vote
        end
        resources :votes, only: [:index]

        namespace :votes do
          resource :participate, only: [:create, :update, :show, :destroy], controller: :participate
          resources :details, only: [:show]
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
