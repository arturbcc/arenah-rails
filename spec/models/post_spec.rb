require 'rails_helper'

describe Post, type: :model do
  it { should belong_to :topic }
  it { should validate_presence_of :message }
  it { should validate_presence_of :topic_id }

  describe '#from_character?' do
    let(:post) { Post.new(character_id: 10) }

    it 'belongs to a character' do
      expect(post.from_character?(10)).to be true
    end

    it 'does not belong to a character' do
      expect(post.from_character?(11)).to be false
    end
  end
end
