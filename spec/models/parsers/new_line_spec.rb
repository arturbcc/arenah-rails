# frozen_string_literal: true

require 'rails_helper'

describe Parsers::NewLine do
  it 'transforms \n into <br/>' do
    expect(Parsers::NewLine.parse('random text with \n')).to eq('random text with <br/>')
  end

  it 'transforms \r\n into <br/>' do
    expect(Parsers::NewLine.parse('random text with \r\n')).to eq('random text with <br/>')
  end
end
