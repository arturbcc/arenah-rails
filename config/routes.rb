Rails.application.routes.draw do
  get ':game/:topic/posts', to: 'posts#index', as: :posts
  get ':game', to: 'games#index', as: :game

  root 'home#index'
end