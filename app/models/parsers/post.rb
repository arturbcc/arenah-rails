# frozen_string_literal: true

class Parsers::Post
  attr_reader :text

  def self.parse(text)
    new(text, default_parsers).text.html_safe
  rescue
    error_message = new('[color=red]** Há alguma coisa errada com suas tags. Verifique se todas estão sendo fechadas corretamente **[/color]\n\n', default_parsers).text.html_safe
    "#{error_message} #{text}".html_safe
  end

  private

  def initialize(text, parsers = [])
    @text = parsers.reduce(text) { |parsed_text, parser| parser.parse(parsed_text) }
  end

  def self.default_parsers
    [Parsers::BBCode, Parsers::Emoji, Parsers::NewLine]
  end
end
