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

    it 'highlights a text' do
      expect(parse('Press [kbd]ENTER[/kbd]')).to eq('Press <kbd>ENTER</kbd>')
    end

    it 'aligns the text' do
      orientations = %W(left right center)
      orientations.each do |orientation|
        expect(parse("[#{orientation}]Text[/#{orientation}]")).to eq("<div style=\"text-align:#{orientation};\">Text</div>")
      end
    end

    it 'justifies the text' do
      expect(parse("[justify]Text[/justify]")).to eq("<div style=\"text-align:justify; text-justify: inter-word;\">Text</div>")
    end

    it 'shows an unordered list of items' do
      expect(parse('[ul][li]List item[/li][li]Another list item[/li][/ul]')).to eq('<ul><li>List item</li><li>Another list item</li></ul>')
    end

    it 'shows a code' do
      expect(parse('This is a [code]code[/code]')).to eq('This is a <pre>code</pre>')
    end

    it 'shows an ordered list of items' do
      expect(parse('[ol][li]List item[/li][li]Another list item[/li][/ol]')).to eq('<ol><li>List item</li><li>Another list item</li></ol>')
    end

    it 'renders an image' do
      expect(parse('[img]http://logo.jpg[/img]')).to eq('<img src="http://logo.jpg" />')
      expect(parse('[img width=10px]http://logo.jpg[/img]')).to eq('<img src="http://logo.jpg" width="10px" />')
      expect(parse('[img height=8px]http://logo.jpg[/img]')).to eq('<img src="http://logo.jpg" height="8px" />')
      expect(parse('[img width=10px height=8px]http://logo.jpg[/img]')).to eq('<img src="http://logo.jpg" width="10px" height="8px" />')
    end

    it 'links to an url' do
      expect(parse('[url]http://www.arenah.com.br/[/url]')).to eq('<a href="http://www.arenah.com.br/">http://www.arenah.com.br/</a>')
      expect(parse('[url=http://www.arenah.com.br/]Google[/url]')).to eq('<a href="http://www.arenah.com.br/">Google</a>')
    end

    it 'renders a quote' do
      expect(parse('[quote]BBCode is great[/quote]')).to eq('<blockquote class="quotation">BBCode is great</blockquote>')
    end

    it 'changes the size of the text' do
      expect(parse('[size=32]This is 32px[/size]')).to eq('<span style="font-size: 32px;">This is 32px</span>')
    end

    it 'changes the color of a text' do
      expect(parse('[color=red]This is red[/color]')).to eq('<font color="red">This is red</font>')
    end

    it 'renders youtube videos' do
      expected = '<iframe id="player" type="text/html" width="400" height="320" src="http://www.youtube.com/embed/E4Fbk52Mk1w?enablejsapi=1" frameborder="0"></iframe>'
      expect(parse('[youtube]E4Fbk52Mk1w[/youtube]')).to eq(expected)
    end

    it 'renders youtube videos with different sizes' do
      expected = '<iframe id="player" type="text/html" width="100" height="320" src="http://www.youtube.com/embed/E4Fbk52Mk1w?enablejsapi=1" frameborder="0"></iframe>'
      expect(parse('[youtube width=100]E4Fbk52Mk1w[/youtube]')).to eq(expected)
      expected = '<iframe id="player" type="text/html" width="400" height="20" src="http://www.youtube.com/embed/E4Fbk52Mk1w?enablejsapi=1" frameborder="0"></iframe>'
      expect(parse('[youtube height=20]E4Fbk52Mk1w[/youtube]')).to eq(expected)
      expected = '<iframe id="player" type="text/html" width="100" height="20" src="http://www.youtube.com/embed/E4Fbk52Mk1w?enablejsapi=1" frameborder="0"></iframe>'
      expect(parse('[youtube width=100 height=20]E4Fbk52Mk1w[/youtube]')).to eq(expected)
    end

    it 'renders vimeo videos' do
      expected = '<iframe src="http://player.vimeo.com/video/46141955?badge=0" width="400" height="320" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      expect(parse('[vimeo]http://vimeo.com/46141955[/vimeo]')).to eq(expected)
    end

    it 'renders vimeo videos with different sizes' do
      expected = '<iframe src="http://player.vimeo.com/video/46141955?badge=0" width="100" height="320" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      expect(parse('[vimeo width=100]http://vimeo.com/46141955[/vimeo]')).to eq(expected)
      expected = '<iframe src="http://player.vimeo.com/video/46141955?badge=0" width="400" height="20" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      expect(parse('[vimeo height=20]http://vimeo.com/46141955[/vimeo]')).to eq(expected)
      expected = '<iframe src="http://player.vimeo.com/video/46141955?badge=0" width="100" height="20" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
      expect(parse('[vimeo width=100 height=20]http://vimeo.com/46141955[/vimeo]')).to eq(expected)
    end

    it 'hides a message to the master' do
      expect(parse('[master]Can I change my attribute?[/master]')).to eq('<div class="bbcode-master"><i class="fa fa-comments fa-2x"></i>Can I change my attribute?</div>')
    end

    it 'shows a dice roll' do
      expect(parse('[dice color=green]1D100 = 73[/dice]')).to eq('<div class="bbcode-dice"><font color="green">1D100 = 73</font></div>')
    end

    it 'shows dices results' do
      expected = 'dice result: <div class="bbcode-full-width"><div class="bbcode-dices"><kbd> Results</kbd><hr/>1d100 = 10</div></div>'
      expect(parse('dice result: [dices=Results]1d100 = 10[/dices]')).to eq(expected)
    end

    it 'renders a line' do
      expect(parse('[line][/line]')).to eq('<hr />')
    end

    it 'inserts a clear div' do
      expect(parse('[clear][/clear]')).to eq('<div class="clear"></div>')
    end

    it 'hides a spoiler' do
      expect(parse('[spoiler=Title]He dies in the end[/spoiler]')).to eq('<span class="bbcode-spoiler"><a href="javascript:;" class="bbcode-spoiler__trigger"><i class="fa fa-plus-square"></i> Title</a><span class="bbcode-spoiler__hidden-text">He dies in the end</span></span>')
    end
  end

  context 'nested tags' do
    it 'applies both both and underline' do
      expect(parse('This is an [b][u]underlined bold[/u][/b] text')).to eq('This is an <strong><u>underlined bold</u></strong> text')
    end
  end

  context 'not closed tag' do
  end

  def parse(text)
    Parsers::BBCode.parse(text)
  end
end
