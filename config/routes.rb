Rails.application.routes.draw do
  get 'sobre', to: 'home#about', as: :about
  get 'museu', to: 'home#museum', as: :museum
  get 'mestres', to: 'home#masters', as: :masters

  get ':game/:topic/posts', to: 'posts#index', as: :posts
  get ':game', to: 'games#index', as: :game

  root 'home#index'
end