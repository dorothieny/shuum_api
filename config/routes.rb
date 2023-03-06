Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, :path_prefix => 'api/v1',
  defaults: { format: :json },
             controllers: {
                 sessions: 'users/sessions',
                 registrations: 'users/registrations'
             }
             scope '/api/v1' do
              resources :users 
                post 'users/:id/follow', to: "users#follow", as: "follow_user"
                post 'users/:id/unfollow', to: "users#unfollow", as: "unfollow_user"
                get 'users/:id/following', :to => "users#following", :as => :following
                get 'users/:id/followed', :to => "users#followed", :as => :followed
                get 'users/:id/liked', :to => "users#liked", :as => :liked
                get 'users/:id/created', :to => "users#created", :as => :created
                get 'users/:id/feed', :to => "users#feed", :as => :feed
                get 'user', :to => "users#current", :as => :current
                put 'users/:id/edit', to: "users#update_info"
              resources :soundcards do 
                resources :likes
                resources :strikes
              end
              get 'newest', :to => "soundcards#newest", :as => :newest
              get 'popular', :to => "soundcards#popular", :as => :popular
              get 'striked', :to => "soundcards#striked", :as => :striked
              get 'random', :to => "soundcards#random", :as => :random
              get 'newshort', :to => "soundcards#newshort", :as => :newshort
              get 'popshort', :to => "soundcards#popshort", :as => :popshort
              resources :tags
            end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
