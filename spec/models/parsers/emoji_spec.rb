require 'rails_helper'

describe Parsers::Emoji do
  context 'invalid emoji' do
    it 'returns the original text' do
      text = ':invald:'
      expect(parse(text)).to eq(text)
    end
  end

  context 'valid emoji' do
    it 'returns an image with the emoji' do
      text = ':laughing:'
      expect(parse(text)).to include('laughing.png')
    end
  end

  def parse(text)
    Parsers::Emoji.parse(text)
  end
end