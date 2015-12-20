Rails.application.routes.draw do
  get 'sobre', to: 'home#about', as: :about
  get 'museu', to: 'home#museum', as: :museum
  get 'mestres', to: 'home#masters', as: :masters

  namespace :admin do
    get ':game/admin', to: 'games#index', as: :game
  end

  get ':game/:topic/posts', to: 'posts#index', as: :posts
  get ':game', to: 'games#show', as: :game
  get ':game/inscricoes', to: 'games#inscriptions', as: :inscription
  get ':game/topicos', to: 'games#topics', as: :topics
  get ':game/personagens', to: 'games#characters', as: :characters
  get ':game/duelos', to: 'games#duels', as: :duels
  get ':game/contato', to: 'games#contact', as: :contact
  get 'sala/criar', to: 'games#new', as: :new_game

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
