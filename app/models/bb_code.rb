class BBCode
  def self.parse(text)
    parsed = text.bbcode_to_html(true, additional_tags)
    parsed.gsub('\r\n', '<br/>').gsub('\n', '<br/>').html_safe
  end

  def self.additional_tags
    {
      b: {
        html_open: '<strong>', html_close: '</strong>',
        description: 'Make text bold',
        example: 'This is [b]bold[/b].'},
      i: {
        html_open: '<em>', html_close: '</em>',
        description: 'Make text italic',
        example: 'This is [i]italic[/i].'},
      u: {
        html_open: '<u>', html_close: '</u>',
        description: 'Underline text',
        example: 'This is [u]underlined[/u].'},
      s: {
        html_open: '<span style="text-decoration:line-through;">', html_close: '</span>',
        description: 'Strike-through text',
        example: 'This is [s]wrong[/s] good.'},
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
      ul: {
        html_open: '<ul>', html_close: '</ul>',
        description: 'Unordered list',
        example: '[ul][li]List item[/li][li]Another list item[/li][/ul].',
        only_allow: [ :li, "*".to_sym ]},
      code: {
        html_open: '<pre>', html_close: '</pre>',
        description: 'Code block with mono-spaced text',
        example: 'This is [code]mono-spaced code[/code].'},
      ol: {
        html_open: '<ol>', html_close: '</ol>',
        description: 'Ordered list',
        example: '[ol][li]List item[/li][li]Another list item[/li][/ol].',
        only_allow: [ :li, "*".to_sym ]},
      li: {
        html_open: '<li>', html_close: '</li>',
        description: 'List item',
        example: '[ul][li]List item[/li][li]Another list item[/li][/ul].',
        only_in: [ :ul, :ol ]},
      list: {
        html_open: '<ul>', html_close: '</ul>',
        description: 'Unordered list',
        example: '[list][*]List item[*]Another list item[/list].',
        only_allow: [ "*".to_sym ]},
      "*".to_sym => {
        html_open: '<li>', html_close: '</li>',
        description: 'List item',
        example: '[list][*]List item[*]Another list item[/list].',
        self_closable: true,
        only_in: [ :list, :ul, :ol ]},
      img: {
        html_open: '<img src="%between%" %width%%height%alt="" />', html_close: '',
        description: 'Image',
        example: '[img]http://www.google.com/intl/en_ALL/images/logo.gif[/img].',
        only_allow: [],
        require_between: true,
        allow_quick_param: true, allow_between_as_param: false,
        quick_param_format: /^(\d+)x(\d+)$/,
        param_tokens: [{token: :width, prefix: 'width="', postfix: '" ', optional: true },
                              { token: :height,  prefix: 'height="', postfix: '" ', optional: true } ],
        quick_param_format_description: 'The image parameters \'%param%\' are incorrect, \'<width>x<height>\' excepted'},
      url: {
        html_open: '<a href="%url%">%between%', html_close: '</a>',
        description: 'Link to another page',
        example: '[url]http://www.google.com/[/url].',
        only_allow: [],
        require_between: true,
        allow_quick_param: true, allow_between_as_param: true,
        quick_param_format: /^((((http|https|ftp):\/\/)|\/).+)$/,
        quick_param_format_description: 'The URL should start with http:// https://, ftp:// or /, instead of \'%param%\'',
        param_tokens: [{ token: :url }]},
      quote: {
        html_open: '<blockquote>', html_close: '</blockquote>',
        description: 'Quote another person',
        example: '[quote]BBCode is great[/quote]'},
      size: {
        html_open: '<span style="font-size: %size%px;">', html_close: '</span>',
        description: 'Change the size of the text',
        example: '[size=32]This is 32px[/size]',
        allow_quick_param: true, allow_between_as_param: false,
        quick_param_format: /(\d+)/,
        quick_param_format_description: 'The size parameter \'%param%\' is incorrect, a number is expected',
        param_tokens: [{token: :size}]},
      color: {
        html_open: '<span style="color: %color%;">', html_close: '</span>',
        description: 'Change the color of the text',
        example: '[color=red]This is red[/color]',
        allow_quick_param: true, allow_between_as_param: false,
        quick_param_format: /(([a-z]+)|(#[0-9a-f]{6}))/i,
        param_tokens: [{token: :color}]},
      youtube: {
        html_open: '<iframe id="player" type="text/html" width="%width%" height="%height%" src="http://www.youtube.com/embed/%between%?enablejsapi=1" frameborder="0"></iframe>', html_close: '',
        description: 'YouTube video',
        example: '[youtube]E4Fbk52Mk1w[/youtube]',
        only_allow: [],
        url_matches: [/youtube\.com.*[v]=([^&]*)/, /youtu\.be\/([^&]*)/, /y2u\.be\/([^&]*)/],
        require_between: true,
        param_tokens: [
          { token: :width, optional: true, default: 400 },
          { token: :height, optional: true, default: 320 }
        ]},
      vimeo: {
        html_open: '<iframe src="http://player.vimeo.com/video/%between%?badge=0" width="%width%" height="%height%" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>',
        html_close: '',
        description: 'Vimeo video',
        example: '[vimeo]http://vimeo.com/46141955[/vimeo]',
        only_allow: [],
        url_matches: [/vimeo\.com\/([^&]*)/],
        require_between: true,
        param_tokens: [
          { token: :width, optional: true, default: 400 },
          { token: :height, optional: true, default: 320 }
        ]},
      media: {
        multi_tag: true,
        require_between: true,
        supported_tags: [
          :youtube,
          :vimeo
        ]
      },
      master: {
        html_open: '<div class="bbcode-master"><i class="fa fa-comments fa-2x"></i>', html_close: '</div>',
        description: 'Send a hidden message to the game master',
        example: '[master]Can I change my attribute?[/master].'},
      dice: {
        html_open: '<div class="bbcode-dice">%between%</div>', html_close: '',
        description: 'Show the result for a simple dice roll',
        require_between: true,
        example: 'dice result: [dice]1d100 = 10[/dice].'},
      dices: {
        html_open: '<div class="bbcode-full-width"><div class="bbcode-dices"><kbd> %title%</kbd><hr/>%between%</div></div>', html_close: '',
        description: 'Show the complete result for a dice roll',
        require_between: true,
        example: 'dice result: [dices=Title]1d100 = 10[/dices].',
        param_tokens: [{ token: :title, optional: true, prefix: 'width=', postfix: ''  }]
      },
      line: {
        html_open: '<hr />', html_close: '',
        description: 'Make a line',
        example: '[line][/line].'},
      clear: {
        html_open: '<div class="clear">', html_close: '</div>',
        description: 'Css clear',
        example: '[clear][/clear].'},
      spoiler: {
        html_open: '<span class="bbcode-spoiler"><a href="javascript:;"><i class="fa fa-plus-square"></i> %title%</a><span>%between%</span></span>', html_close: '',
        description: 'Show a hidden spoiler',
        example: '[spoiler=Title]Ele morre no final[/dices].',
        param_tokens: [{ token: :title, optional: true }]
      }
    }
  end
end