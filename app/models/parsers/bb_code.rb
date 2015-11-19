class Parsers::BBCode
  def self.parse(text)
    text.bbcode_to_html(true, additional_tags)
  end

  private

  def self.additional_tags
    {
      kbd: {
        html_open: '<kbd>', html_close: '</kbd>',
        description: 'Highlight the text',
        example: 'Press [kbd]enter[/kbd].'},
      left: {
        html_open: '<div style="text-align:left;">', html_close: '</div>',
        description: 'Aligns a text in the left',
        example: '[left]This is centered[/left].'},
      right: {
        html_open: '<div style="text-align:right;">', html_close: '</div>',
        description: 'Aligns a text in the right',
        example: '[right]This is centered[/right].'},
      center: {
        html_open: '<div style="text-align:center;">', html_close: '</div>',
        description: 'Center a text',
        example: '[center]This is centered[/center].'},
      justify: {
        html_open: '<div style="text-align:justify; text-justify: inter-word;">', html_close: '</div>',
        description: 'Justify a text',
        example: '[justify]This is centered[/justify].'},
      code: {
        html_open: '<pre>', html_close: '</pre>',
        description: 'Code block with mono-spaced text',
        example: 'This is [code]mono-spaced code[/code].'},
      img: {
        html_open: '<img src="%between%" %width%%height%/>', html_close: '',
        description: 'Image',
        example: '[img]http://www.google.com/intl/en_ALL/images/logo.gif[/img].',
        only_allow: [],
        require_between: true,
        allow_quick_param: true, allow_between_as_param: false,
        quick_param_format: /^(\d+)x(\d+)$/,
        param_tokens: [
          { token: :width, prefix: 'width="', postfix: '" ', optional: true },
          { token: :height,  prefix: 'height="', postfix: '" ', optional: true } ],
        quick_param_format_description: 'The image parameters \'%param%\' are incorrect, \'<width>x<height>\' excepted'},
      quote: {
        html_open: '<blockquote>', html_close: '</blockquote>',
        description: 'Quote another person',
        example: '[quote]BBCode is great[/quote]'},
      color: {
        html_open: '<font color="%color%">', html_close: '</font>',
        description: 'Change the color of the text',
        example: '[color=red]This is red[/color]',
        allow_quick_param: true, allow_between_as_param: false,
        quick_param_format: /(([a-z]+)|(#[0-9a-f]{6}))/i,
        param_tokens: [{token: :color}]},
      master: {
        html_open: '<div class="bbcode-master"><i class="fa fa-comments fa-2x"></i>', html_close: '</div>',
        description: 'Send a hidden message to the game master',
        example: '[master]Can I change my attribute?[/master].'},
      dice: {
        html_open: '<div class="bbcode-dice"><font color="%color%">', html_close: '</font></div>',
        description: 'Show the result for a simple dice roll',
        example: 'dice result: [dice]1d100 = 10[/dice].',
        allow_quick_param: true,
        allow_between_as_param: false,
        quick_param_format: /(([a-z]+)|(#[0-9a-f]{6}))/i,
        param_tokens: [{ token: :color, optional: true, default: '#000' }]},
      dices: {
        html_open: '<div class="bbcode-full-width"><div class="bbcode-dices"><kbd> %dices%</kbd><hr/>', html_close: '</div></div>',
        description: 'Show the complete result for dice rolls',
        example: 'dice result: [dices=Title]1d100 = 10[/dices].',
        allow_quick_param: true,
        allow_between_as_param: false,
        quick_param_format: /([\w\s]*)/i,
        param_tokens: [{ token: :dices, optional: true, default: 'Rolagens' }]},
      line: {
        html_open: '<hr />', html_close: '',
        description: 'Make a line',
        example: '[line][/line].'},
      clear: {
        html_open: '<div class="clear">', html_close: '</div>',
        description: 'Css clear',
        example: '[clear][/clear].'},
      spoiler: {
        html_open: '<span class="bbcode-spoiler"><a href="javascript:;"><i class="fa fa-plus-square"></i> %title%</a><span>', html_close: '</span></span>',
        description: 'Show a hidden spoiler',
        example: '[spoiler=Title]He dies in the end[/spoiler].',
        param_tokens: [{ token: :title, optional: true, default: '' }]
      }
    }
  end
end