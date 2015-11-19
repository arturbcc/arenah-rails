class Parsers::Post
  attr_reader :text

  def self.parse(text)
    new(text, default_parsers).text.html_safe
  end

  private

  def initialize(text, parsers = [])
    @text = parsers.reduce(text) { |parsed, parser| parser.parse(parsed) }
  end

  def self.default_parsers
    [Parsers::BBCode, Parsers::Emoji, Parsers::NewLine]
  end
end