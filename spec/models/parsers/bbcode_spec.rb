require 'rails_helper'

describe Parsers::BBCode do
  context 'invalid tag' do
    it 'returns the original text' do
      text = '[Coraline] is here'
      expect(parse(text)).to eq(text)
    end
  end

  context 'valid tags' do
    it 'applies bold' do
      expect(parse('I said [b]no[/b], do you understand?')).to eq('I said <strong>no</strong>, do you understand?')
    end

    it 'applies italic' do
      expect(parse('You are [i]brilliant[/i]')).to eq('You are <em>brilliant</em>')
    end

    it 'applies underscore' do
      expect(parse('Do it [u]now[/u]')).to eq('Do it <u>now</u>')
    end

    it 'applies strike through' do
      expect(parse('I [s]hate[/s] love it')).to eq('I <span style="text-decoration:line-through;">hate</span> love it')
    end
  end

  context 'nested tags' do
  end

  def parse(text)
    Parsers::BBCode.parse(text)
  end
end