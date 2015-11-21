require 'rails_helper'

describe PostHelper do
  describe '#recipients_names' do
    before do
      user = create(:user)
      master = create(:character, user: user)
      game = create(:game, character: master)
      @character1 = create(:character, name: 'Jane Roe', user: user, game: game)
      @character2 = create(:character, name: 'John Doe', user: user, game: game)
      @post = create(:post, topic: create(:topic))
    end

    context 'empty recipients' do
      it 'returns an empty string' do
        expect(helper.recipients_names(@post)).to be_empty
      end
    end

    context 'post with recipients' do
      it 'lists the names of the characters' do
        create(:post_recipient, post: @post, character: @character1)
        create(:post_recipient, post: @post, character: @character2)
        expect(helper.recipients_names(@post)).to eq 'Jane Roe, John Doe'
      end
    end
  end
end