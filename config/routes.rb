Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/api' do
    resources :users, only: :create
    resources :events do
      resources :comments, except: :show
      resources :attachments, only: [:create, :destroy]
    end
    post 'events/:id/invite', to: 'events#invite'
    get  'events/:id/feed',   to: 'events#feed'
  end
end
