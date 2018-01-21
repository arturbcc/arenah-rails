# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity, type: :model do
  context 'invalid role' do
    it 'is unlogged if no role is provided' do
      expect(Identity.new).to be_unlogged
    end

    it 'is unlogged if an invalid role is provided' do
      expect(Identity.new(:admin)).to be_unlogged
    end
  end

  context 'valid role' do
    it 'is unlogged' do
      expect(Identity.new(:unlogged)).to be_unlogged
    end

    it 'is player' do
      expect(Identity.new(:player)).to be_player
    end

    it 'is visitor' do
      expect(Identity.new(:visitor)).to be_visitor
    end

    it 'is game_master' do
      expect(Identity.new(:game_master)).to be_game_master
    end

    it 'is not unlogged' do
      expect(Identity.new(:player)).to_not be_unlogged
    end

    it 'is not a player' do
      expect(Identity.new(:visitor)).to_not be_player
    end

    it 'is not a visitor' do
      expect(Identity.new(:game_master)).to_not be_visitor
    end

    it 'is not a game master' do
      expect(Identity.new(:unlogged)).to_not be_game_master
    end
  end

  describe '#read_only?' do
    it 'is read only if the user is unlogged' do
      expect(Identity.new(:unlogged)).to be_read_only
    end

    it 'is read only if the user a visitor' do
      expect(Identity.new(:visitor)).to be_read_only
    end

    it 'is not read only if the user is a player' do
      expect(Identity.new(:player)).to_not be_read_only
    end

    it 'is not read only if the user is a game master' do
      expect(Identity.new(:game_master)).to_not be_read_only
    end
  end

  describe '#logged?' do
    it 'is logged if the user is a visitor' do
      expect(Identity.new(:visitor)).to be_logged
    end

    it 'is logged if the user is a player' do
      expect(Identity.new(:player)).to be_logged
    end

    it 'is logged if the user is a game master' do
      expect(Identity.new(:game_master)).to be_logged
    end

    it 'is not logged if the user is unlogged' do
      expect(Identity.new(:unlogged)).to_not be_logged
    end
  end
end
