# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#excerpt' do
    it 'returns the whole string if it fits on the expected characters range' do
      message = Message.new(body: 'This is a short message')
      expect(message.excerpt(200)).to eq(message.body)
    end

    it 'returns the cropped string' do
      message = Message.new(body: 'This is a message that will be cropped')
      expect(message.excerpt(12)).to eq('This is a...')
      expect(message.excerpt(13)).to eq('This is a ...')
      expect(message.excerpt(14)).to eq('This is a m...')
      expect(message.excerpt(18)).to eq('This is a messa...')
    end

    it 'ignores html tag when cropping' do
      message = Message.new(body: '<b>This</b> is a <font color="red">message</font> that will be cropped')
      expect(message.excerpt(18)).to eq('This is a messa...')
    end
  end
end
