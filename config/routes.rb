Rails.application.routes.draw do
  get 'sobre', to: 'home#about', as: :about
  get 'museu', to: 'home#museum', as: :museum
  get 'mestres', to: 'home#masters', as: :masters

  namespace :admin do
    get ':game/admin', to: 'games#index', as: :game
  end

  namespace :game, path: '' do
    get ':game/:topic/posts', to: 'posts#index', as: :posts
    get ':game/inscreva-se', to: 'subscription#show', as: :subscription
    get ':game/topicos', to: 'home#topics', as: :topics
    get ':game/personagens', to: 'home#characters', as: :characters
    get ':game/duelos', to: 'home#duels', as: :duels
    get ':game/contato', to: 'home#contact', as: :contact
    get ':game', to: 'home#show', as: :home

    #TODO: Fix this alias new_game
    get 'sala/criar', to: 'home#new', as: :new
  end

  resources :posts, only: :destroy

  get 'tour/mestres', to: 'tour#masters', as: :masters_tour
  get 'tour/jogadores', to: 'tour#players', as: :players_tour

  namespace :passport, as: :passport, path: 'passaporte' do
    get 'register', path: 'registro'
    get 'login'
    get 'logout'
  end

  resources :profile, only: :edit, path: 'perfil'

  root 'home#index'
end
