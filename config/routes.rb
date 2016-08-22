RssPoster::Engine.routes.draw do
  get '/' => 'feeds#index'
  resources :feeds
end
