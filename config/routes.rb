Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users

  get 'sobre', to: 'about#show', as: :about
  get 'arquivo', to: 'archive#index', as: :archive
  get 'mestres', to: 'home#masters', as: :masters

  scope :admin do
    get ':game', to: 'game/games#index', as: :game
  end

  namespace :game, path: '' do
    get ':game/:topic/posts', to: 'posts#index', as: :posts
    get ':game/:topic/post/criar', to: 'posts#new', as: :new_post
    get ':game/:topic/post/:id/responder', to: 'posts#new', as: :reply_post
    get ':game/:topic/post/:id/editar', to: 'posts#edit', as: :edit_post
    patch ':game/:topic/post/:id', to: 'posts#update', as: :update_post
    delete ':game/:topic/post/:id', to: 'posts#destroy', as: :delete_post, defaults: { format: :json }
    post ':game/:topic/post/', to: 'posts#create', as: :create_post
    post ':game/:topic/post/preview', to: 'post_preview#show', as: :preview_post

    # Check if we still need this route
    resources :posts, only: :destroy

    get ':game/:topic/post/iniciativas', to: 'initiatives#show', as: :initiatives
    get ':game/:topic/post/danos', to: 'damages#show', as: :damages
    post ':game/:topic/post/causar-danos', to: 'damages#create', as: :cause_damage

    resources :topics, path: ':game/topicos', param: :topic do
      post 'reordenar', to: 'topics#sort', on: :collection, as: :sort
      get 'entrar', to: 'topic_destination#show', on: :member, as: :redirect_to_topic_destination_page
    end

    resources :topic_groups, path: ':game/grupo-de-topicos', param: :topic_group do
      post 'reordenar', to: 'topic_groups#sort', on: :collection, as: 'sort'
    end

    get ':game/personagens', to: 'characters#index', as: :characters
    # TODO: What is the differente between the route above and below?
    get ':game/personagens/lista', to: 'characters#list', as: :characters_list
    # get ':game/personagem/:character/ficha', to: 'characters#sheet', as: :sheet

    get ':game/duelos', to: 'duels#index', as: :duels
    get ':game/duelo/:id', to: 'duels#show', as: :duel

    get ':game/contato', to: 'contact#new', as: :new_contact
    post ':game/contato/criar', to: 'contact#create', as: :create_contact

    get ':game', to: 'home#show', as: :home

    get ':game/inscreva-se', to: 'subscription#show', as: :subscription
    post ':game/subscribe', to: 'subscription#create', as: :subscribe
    delete ':game/unsubscribe', to: 'subscription#destroy', as: :unsubscribe, defaults: { format: :json }

    get ':game/sistema', to: 'system#show', as: :system

    get 'sala/criar', to: 'home#new', as: :new

    resources :sheet, only: [:show, :update], param: :character_slug, path: ':game/ficha'

    get 'personagem/trocar-para/:game/:character', to: 'change_character#show', as: :change_character
  end


  get 'tour/mestres', to: 'tours#for_masters', as: :masters_tour
  get 'tour/jogadores', to: 'tours#for_players', as: :players_tour
  resources :profile, only: [:edit, :update], path: 'perfil'

  root 'home#index'
end
