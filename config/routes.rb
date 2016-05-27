Rails.application.routes.draw do
  devise_for :users
  # devise_for :users, path: 'auth', path_names: {
  #   sign_in: 'login', sign_out: 'logout', password: 'secret',
  #   confirmation: 'verification', unlock: 'unblock', registration: 'register',
  #   sign_up: 'cmon_let_me_in' }

  get 'sobre', to: 'about#show', as: :about
  get 'arquivo', to: 'archive#index', as: :archive
  get 'mestres', to: 'home#masters', as: :masters

  namespace :admin do
    get ':game/admin', to: 'games#index', as: :game
  end

  namespace :game, path: '' do
    get ':game/:topic/posts', to: 'posts#index', as: :posts
    get ':game/:topic/post/criar', to: 'posts#new', as: :new_post
    get ':game/:topic/post/:id/responder', to: 'posts#new', as: :reply_post
    get ':game/:topic/post/:id/editar', to: 'posts#edit', as: :edit_post
    patch ':game/:topic/post/:id', to: 'posts#update', as: :update_post
    delete ':game/:topic/post/:id', to: 'posts#destroy', as: :delete_post
    post ':game/:topic/post/', to: 'posts#create', as: :create_post
    post ':game/:topic/post/preview', to: 'post_preview#show', as: :preview_post

    get ':game/:topic/post/iniciativas', to: 'initiatives#show', as: :initiatives
    get ':game/:topic/post/danos', to: 'damages#show', as: :damages
    post ':game/:topic/post/causar-danos', to: 'damages#create', as: :cause_damage


    resources :topics, path: ':game/topicos', param: :topic do
      post 'reordenar', to: 'topics#sort', on: :collection, as: :sort
    end

    # get ':game/topicos', to: 'topics#index', as: :topics
    # post ':game/topicos/reordenar', to: 'topics#sort', as: :sort_topics
    # delete ':game/topicos/:topic', to: 'topics#destroy', as: :delete_topic
    # get ':game/topico/novo', to: 'topics#new', as: :new_topic
    # post ':game/topico/criar', to: 'topics#create', as: :create_topic
    # get ':game/topico/:id/editar', to: 'topics#edit', as: :edit_topic

    resources :topic_groups, path: ':game/grupo-de-topicos' do
      post 'reordenar', to: 'topic_groups#sort', on: :collection, as: 'sort'
    end
    # get ':game/grupo-de-topicos/:id/editar', to: 'topic_group#edit', as: :edit_topic_group
    # delete ':game/grupo-de-topicos/:id/apagar', to: 'topic_groups#destroy', as: :delete_topic_group
    # post ':game/grupo-de-topicos/reordenar', to: 'topic_groups#sort', as: :sort_groups
    # get ':game/grupo-de-topicos/novo', to: 'topic_groups#new', as: :new_topic_group
    # post ':game/grupo-de-topicos/criar', to: 'topic_groups#create', as: :create_topic_group

    get ':game/personagens', to: 'characters#index', as: :characters
    # TODO: What is the differente between the route above and below?
    get ':game/personagens/lista', to: 'characters#list', as: :characters_list
    get ':game/personagem/:character/ficha', to: 'characters#sheet', as: :character_sheet

    get ':game/duelos', to: 'duels#index', as: :duels
    get ':game/duelo/:id', to: 'duels#show', as: :duel

    get ':game/contato', to: 'contact#new', as: :new_contact
    post ':game/contato/criar', to: 'contact#create', as: :create_contact

    get ':game', to: 'home#show', as: :home

    get ':game/inscreva-se', to: 'subscription#show', as: :subscription
    post ':game/subscribe', to: 'subscription#create', as: :subscribe
    delete ':game/unsubscribe', to: 'subscription#destroy', as: :unsubscribe

    get ':game/sistema', to: 'game#show', as: :system

    get 'sala/criar', to: 'home#new', as: :new

    resources :sheet, only: :show, param: :character_slug, path: '/ficha'
  end

  resources :posts, only: :destroy

  get 'tour/mestres', to: 'tours#for_masters', as: :masters_tour
  get 'tour/jogadores', to: 'tours#for_players', as: :players_tour

  # namespace :passport, as: :passport, path: 'passaporte' do
  #   get 'register', path: 'registro'
  #   get 'login'
  #   get 'logout'
  # end
  #
  resources :profile, only: [:edit, :update], path: 'perfil'

  root 'home#index'
end
