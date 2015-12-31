require 'rails_helper'

describe Parsers::Post do
  it 'parses bbcode from text' do
    expect(parse('[b]Text[/b]')).to eq('<strong>Text</strong>')
  end

  it 'parses new lines from text' do
    expect(parse('Text \r\nNew line')).to eq('Text <br/>New line')
  end

  it 'parses emoji from text' do
    expect(parse(':grin:')).to eq('<img class="emoji" src="/images/emoji/grin.png" alt="Grin" />')
  end

  def parse(text)
    Parsers::Post.parse(text)
  end
end
