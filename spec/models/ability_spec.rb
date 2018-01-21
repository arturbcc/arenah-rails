require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:master_identity) { Identity.new(:game_master) }
  let(:unlogged_identity) { Identity.new(:unlogged) }
  let(:visitor_identity) { Identity.new(:visitor) }
  let(:player_identity) { Identity.new(:player) }

  let(:user) { create(:user) }
  let(:character) { create(:character, user: user) }
  let(:game) { create(:game, character: character) }
  let(:topic_group) { create(:topic_group, game: game) }
  let(:topic) { create(:topic, topic_group: topic_group, game_id: game.id) }

  context 'game master' do
    let(:subject) { Ability.new(master_identity, build(:post)) }

    it { is_expected.to be_can_delete }
    it { is_expected.to be_can_edit }
    it { is_expected.to be_can_reply }
  end

  context 'game master interacting with an active character' do
    let(:subject) { Ability.new(master_identity, build(:post), build(:character)) }

    it { is_expected.to be_can_send_alert }
    it { is_expected.to be_can_send_message }
  end

  context 'game master interacting with an inactive character' do
    let(:subject) { Ability.new(master_identity, build(:post), build(:character, status: 0)) }

    it { is_expected.not_to be_can_send_alert }
    it { is_expected.not_to be_can_send_message }
  end

  context 'visitor trying to modify a player\'s post' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(visitor_identity, build(:post), character) }

    it { is_expected.not_to be_can_delete }
    it { is_expected.not_to be_can_edit }
    it { is_expected.not_to be_can_reply }
  end

  context 'visitor trying to interact with players' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(visitor_identity, build(:post), character) }

    it { is_expected.not_to be_can_send_alert }
    it { is_expected.to be_can_send_message }
  end

  context 'player trying to modify other player\'s post' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(player_identity, build(:post), character) }

    it { is_expected.not_to be_can_delete }
    it { is_expected.not_to be_can_edit }
    it { is_expected.not_to be_can_reply }
  end

  context 'player trying to interact with other players' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(player_identity, build(:post), character) }

    it { is_expected.not_to be_can_send_alert }
    it { is_expected.to be_can_send_message }
  end

  context 'unlogged trying to modify player\'s post' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(unlogged_identity, build(:post), character) }

    it { is_expected.not_to be_can_delete }
    it { is_expected.not_to be_can_edit }
    it { is_expected.not_to be_can_reply }
  end

  context 'unlogged trying to interact with players' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(unlogged_identity, build(:post), character) }

    it { is_expected.not_to be_can_send_alert }
    it { is_expected.not_to be_can_send_message }
  end

  context 'author trying to modify a player\'s post' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(player_identity, build(:post), character) }

    it { is_expected.not_to be_can_delete }
    it { is_expected.not_to be_can_edit }
    it { is_expected.not_to be_can_reply }
  end

  context 'author trying to modify his post' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(player_identity, build(:post, character: character), character) }

    it { is_expected.to be_can_delete }
    it { is_expected.to be_can_edit }
    it { is_expected.not_to be_can_reply }

    it 'can reply if he is the recipient of the post' do
      ability = Ability.new(player_identity,
        build(:post, character: character, recipients: [character]), character)
      expect(ability.can_reply?).to be true
    end
  end

  context 'author trying to interact with players' do
    let(:character) { create(:character, user: user) }
    let(:subject) { Ability.new(player_identity, build(:post), character) }

    it { is_expected.not_to be_can_send_alert }
    it { is_expected.to be_can_send_message }
  end

  describe '#author?' do
    it 'is not author if character is nil' do
      ability = Ability.new(master_identity, build(:post))
      expect(ability).not_to be_author
    end

    it 'is not author if no post was provided' do
      character = create(:character, user: user)
      ability = Ability.new(master_identity, nil, character)
      expect(ability).not_to be_author
    end

    it 'is not author if no post does not belong to character' do
      character = create(:character, user: user)
      post = create(:post, topic: topic, character: create(:character, user: user))
      ability = Ability.new(master_identity, post, character)
      expect(ability).not_to be_author
    end

    it 'is author if no post belongs to character' do
      character = create(:character, user: user)
      post = create(:post, topic: topic, character: character)
      ability = Ability.new(master_identity, post, character)
      expect(ability).to be_author
    end
  end

  describe '#recipient?' do
    it 'is not a recipient if character is nil' do
      ability = Ability.new(master_identity, build(:post))
      expect(ability).not_to be_recipient
    end

    it 'is not a recipient if no post was provided' do
      character = create(:character, user: user)
      ability = Ability.new(master_identity, nil, character)
      expect(ability).not_to be_recipient
    end

    it 'is a recipient if the character is in the post\'s recipient list' do
      sender = create(:character, user: user, name: 'Jane sender')
      post = create(:post, topic: topic, recipients: [character], character: sender)
      ability = Ability.new(master_identity, post, character)
      expect(ability).to be_recipient
    end
  end
end
