# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game::PostsController, type: :controller do
  describe '#delete' do
    let(:game_master_user) { create(:user, name: 'John Doe') }
    let(:game_master_character) { create(:character, user: game_master_user, name: 'Game master') }
    let!(:game) { create(:game, character: game_master_character) }
    let(:topic_group) { create(:topic_group, game: game) }
    let!(:topic) { create(:topic, topic_group: topic_group, game_id: game.id) }

    let(:player1_user) { create(:user, name: 'Jane Roe') }
    let!(:player1_character) { create(:character, user: player1_user, name: 'Player 1', game: game) }

    let(:player2_user) { create(:user, name: 'Mary Loe') }
    let!(:player2_character) { create(:character, user: player2_user, name: 'Player 2', game: game) }

    it 'prevents unlogged users from deleting a post' do
      post = create(:post, topic: topic, character: player1_character)

      delete :destroy, params: { game: game, topic: topic, id: post.id, format: 'json' }

      expect(response.status).to eq(401)
    end

    it 'prevents a user from deleting other user\'s post' do
      post = create(:post, topic: topic, character: player2_character)

      sign_in_user(player1_user)
      delete :destroy, params: { game: game, topic: topic, id: post.id, format: 'json' }

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'prevents a game master from deleting a post from other game' do
      new_game = create(:game, character: player2_character)
      new_topic_group = create(:topic_group, game: new_game)
      new_topic = create(:topic, topic_group: new_topic_group, game_id: game.id)
      post = create(:post, topic: new_topic, character: player2_character)

      sign_in_user(game_master_user)
      delete :destroy, params: { game: new_game, topic: new_topic, id: post.id, format: 'json' }

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'ignores inexistent posts' do
      sign_in_user(game_master_user)

      delete :destroy, params: { game: game, topic: topic, id: 0, format: 'json' }

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'allows a master to delete posts from his players' do
      post = create(:post, topic: topic, character: player1_character)

      sign_in_user(game_master_user)
      delete :destroy, params: { game: game, topic: topic, id: post.id, format: 'json' }

      json = JSON.parse(response.body)
      expect(json['status']).to eq(200)
    end

    it 'allows a user to delete his/her posts' do
      post = create(:post, topic: topic, character: player1_character)

      sign_in_user(player1_user)
      delete :destroy, params: { game: game, topic: topic, id: post.id, format: 'json' }

      json = JSON.parse(response.body)
      expect(json['status']).to eq(200)
    end
  end

  private

  def sign_in_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in(user)
  end
end
