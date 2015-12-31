require 'rails_helper'

describe Parsers::Post do
  it 'parses bbcode from text' do
    expect(parse('[b]Text[/b]')).to eq('<strong>Text</strong>')
  end

  it 'parses new lines from text' do
    expect(parse('Text \r\nNew line')).to eq('Text <br/>New line')
  end

  def parse(text)
    Parsers::Post.parse(text)
  end
end
