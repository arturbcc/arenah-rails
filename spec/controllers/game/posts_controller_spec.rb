# frozen_string_literal: true

require 'rails_helper'

describe Game::PostsController do
  let(:user) { create(:user) }
  let!(:game) { create(:game) }
  let!(:topic) { create(:topic, game: game) }

  describe '#delete' do
    it 'prevents unlogged users from deleting a post' do
      delete :destroy, game: game, topic: topic, id: 1, format: 'json'

      expect(response.status).to eq(401)
    end

    it 'prevents a user from deleting other user\'s post' do
      post = create(:post, topic: topic)

      sign_in_user(user)
      delete :destroy, game: game, topic: topic, id: post.id, format: 'json'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'prevents a game master from deleting a post from other game' do
      master = create(:character, :game_master, user: user)
      post = create(:post, topic: topic)

      sign_in_user(user)
      delete :destroy, game: game, topic: topic, id: post.id, format: 'json'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'ignores inexistent posts' do
      character = create(:character, user: user, game: game)
      post = create(:post, topic: topic, character: character)

      sign_in_user(user)
      delete :destroy, game: game, topic: topic, id: (post.id + 1), format: 'json'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(422)
    end

    it 'allows a master to delete posts from his players' do
      master = create(:character, :game_master, user: user, game: game)
      post = create(:post, topic: topic)

      sign_in_user(user)
      delete :destroy, game: game, topic: topic, id: post.id, format: 'json'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(200)
    end

    it 'allows a user to delete his/her posts' do
      game = create(:game)
      character = create(:character, user: user, game: game)
      topic = create(:topic, game: game)
      post = create(:post, topic: topic, character: character)

      sign_in_user(user)
      delete :destroy, game: game, topic: topic, id: post.id, format: 'json'

      json = JSON.parse(response.body)
      expect(json['status']).to eq(200)
    end
  end

  private

  def sign_in_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end
