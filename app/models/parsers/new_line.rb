# frozen_string_literal: true

class Parsers::NewLine
  def self.parse(text)
    text.gsub('\r\n', '<br/>').gsub('\n', '<br/>')
  end
end
