Rails.application.routes.draw do
  devise_for :users
  # devise_for :users, path: 'auth', path_names: {
  #   sign_in: 'login', sign_out: 'logout', password: 'secret',
  #   confirmation: 'verification', unlock: 'unblock', registration: 'register',
  #   sign_up: 'cmon_let_me_in' }

  get 'sobre', to: 'home#about', as: :about
  get 'museu', to: 'home#museum', as: :museum
  get 'mestres', to: 'home#masters', as: :masters

  namespace :admin do
    get ':game/admin', to: 'games#index', as: :game
  end

  namespace :game, path: '' do
    get ':game/:topic/posts', to: 'posts#index', as: :posts
    get ':game/inscreva-se', to: 'subscription#show', as: :subscription
    get ':game/topicos', to: 'topics#index', as: :topics
    get ':game/topico/:id/editar', to: 'topics#edit', as: :edit_topic
    get ':game/grupo-de-topicos/:id/editar', to: 'topic_group#edit', as: :edit_topic_group
    get ':game/personagens', to: 'characters#index', as: :characters
    get ':game/duelos', to: 'duels#index', as: :duels
    get ':game/duelo/:id', to: 'duels#show', as: :duel
    get ':game/contato', to: 'contact#show', as: :contact
    get ':game', to: 'home#show', as: :home

    post ':game/topicos/novo', to: 'topics#create', as: :new_topic
    post ':game/subscribe', to: 'subscription#create', as: :subscribe
    delete ':game/unsubscribe', to: 'subscription#destroy', as: :unsubscribe

    get ':game/personagem/:character/ficha', to: 'characters#sheet', as: :character_sheet

    #TODO: Fix this alias new_game
    get 'sala/criar', to: 'home#new', as: :new
  end

  resources :posts, only: :destroy

  get 'tour/mestres', to: 'tour#masters', as: :masters_tour
  get 'tour/jogadores', to: 'tour#players', as: :players_tour

  # namespace :passport, as: :passport, path: 'passaporte' do
  #   get 'register', path: 'registro'
  #   get 'login'
  #   get 'logout'
  # end
  #
  resources :profile, only: :edit, path: 'perfil'


  root 'home#index'
end
