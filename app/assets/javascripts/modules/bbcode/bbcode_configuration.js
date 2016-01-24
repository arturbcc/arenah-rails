// ----------------------------------------------------------------------------
// markItUp!
// ----------------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// ----------------------------------------------------------------------------
// BBCode tags example
// http://en.wikipedia.org/wiki/Bbcode
// ----------------------------------------------------------------------------
// Feel free to add more tags
// ----------------------------------------------------------------------------

var mySettings = {
  previewParserPath: '', // path to your BBCode parser
  markupSet: [
		  { name: 'Negrito', openWith: '[b]', closeWith: '[/b]' },
		  { name: 'Itálico', openWith: '[i]', closeWith: '[/i]' },
		  { name: 'Sublinhado', openWith: '[u]', closeWith: '[/u]' },
		  { name: 'Tachado', openWith: '[s]', closeWith: '[/s]' },
		  { separator: '---------------' },
		  { name: 'Imagem', replaceWith: '[img][![Url]!][/img]' },
		  { name: 'Link', openWith: '[url=[![Url]!]]', closeWith: '[/url]', placeHolder: 'Your text to link here...' },
		  { separator: '---------------' },
		  { name: 'Cores', openWith: '[color=[![Color]!]]', closeWith: '[/color]', dropMenu: [
          { name: 'Preto', openWith: '[color=#000]', closeWith: '[/color]', className: "black" },
          { name: "Foquete", openWith: '[color=#800000]', closeWith: '[/color]', className: "foquete" },
          { name: "Marrom 1", openWith: '[color=#8B4513]', closeWith: '[/color]', className: "marrom1" },
          { name: "Cinza 1", openWith: '[color=#2F4F4F]', closeWith: '[/color]', className: "cinza1" },
          { name: "Cerceta", openWith: '[color=#008080]', closeWith: '[/color]', className: "cerceta" },
          { name: "Azul Marinho", openWith: '[color=#000080]', closeWith: '[/color]', className: "azul-marinho" },
          { name: "Índigo", openWith: '[color=#4B0082]', closeWith: '[/color]', className: "indigo" },
          { name: "Cinza 2", openWith: '[color=#696969]', closeWith: '[/color]', className: "cinza2" },

          { name: "Tijolo de Fogo", openWith: '[color=#B22222]', closeWith: '[/color]', className: "tijolo-de-fogo" },
          { name: "Marrom 2", openWith: '[color=#A52A2A]', closeWith: '[/color]', className: "marrom2" },
          { name: "Vara Dourada", openWith: '[color=#DAA520]', closeWith: '[/color]', className: "vara-dourada" },
          { name: "Verde Escuro", openWith: '[color=#006400]', closeWith: '[/color]', className: "verde-escuro" },
          { name: "Turquesa", openWith: '[color=#40E0D0]', closeWith: '[/color]', className: "turqueza" },
          { name: "Azul Médio", openWith: '[color=#0000CD]', closeWith: '[/color]', className: "azul-medio" },
          { name: 'Roxo', openWith: '[color=purple]', closeWith: '[/color]', className: "purple" },
          { name: "Cinza 3", openWith: '[color=#808080]', closeWith: '[/color]', className: "cinza3" },

          { name: 'Vermelho', openWith: '[color=red]', closeWith: '[/color]', className: "red" },
          { name: "Laranja Escuro", openWith: '[color=#FF8C00]', closeWith: '[/color]', className: "laranja-escuro" },
          { name: "Dourado", openWith: '[color=#FFD700]', closeWith: '[/color]', className: "dourado" },
          { name: 'Verde', openWith: '[color=green]', closeWith: '[/color]', className: "green" },
          { name: "Ciano", openWith: '[color=#00FFFF]', closeWith: '[/color]', className: "ciano" },
          { name: 'Azul', openWith: '[color=blue]', closeWith: '[/color]', className: "blue" },
          { name: "Violeta", openWith: '[color=#EE82EE]', closeWith: '[/color]', className: "violeta" },
          { name: "Cinza Escuro", openWith: '[color=#A9A9A9]', closeWith: '[/color]', className: "cinza-escuro" },

          { name: "Salmão Claro", openWith: '[color=#FFA07A]', closeWith: '[/color]', className: "salmao-claro" },
		        { name: 'Laranja', openWith: '[color=orange]', closeWith: '[/color]', className: "orange" },
          { name: 'Amarelo', openWith: '[color=yellow]', closeWith: '[/color]', className: "yellow" },
          { name: "Lima", openWith: '[color=#00FF00]', closeWith: '[/color]', className: "lima" },
          { name: "Turquesa Pálido", openWith: '[color=#AFEEEE]', closeWith: '[/color]', className: "turqueza-palido" },
          { name: "Azul Claro", openWith: '[color=#ADD8E6]', closeWith: '[/color]', className: "azul-claro" },
          { name: "Ameixa", openWith: '[color=#DDA0DD]', closeWith: '[/color]', className: "ameixa" },
          { name: "Cinza Claro", openWith: '[color=#D3D3D3]', closeWith: '[/color]', className: "cinza-claro" },

          { name: "Lavanda 1", openWith: '[color=#FFF0F5]', closeWith: '[/color]', className: "lavanda1" },
          { name: "Branco Antiguidade", openWith: '[color=#FAEBD7]', closeWith: '[/color]', className: "branco-antiguidade" },
          { name: "Amarelo Claro", openWith: '[color=#FFFFE0]', closeWith: '[/color]', className: "amarelo-claro" },
          { name: "Orvalho", openWith: '[color=#F0FFF0]', closeWith: '[/color]', className: "orvalho" },
          { name: "Azure", openWith: '[color=#F0FFFF]', closeWith: '[/color]', className: "azure" },
          { name: "Azul Alice", openWith: '[color=#F0F8FF]', closeWith: '[/color]', className: "azul-alice" },
          { name: "Lavanda 2", openWith: '[color=#E6E6FA]', closeWith: '[/color]', className: "lavanda2" },
          { name: 'Branco', openWith: '[color=white]', closeWith: '[/color]', className: "white" }]
		  },

		  { name: 'Tamanho', openWith: '[size=[![Text size]!]]', closeWith: '[/size]', dropMenu: [
			    { name: 'Grande', openWith: '[size=25px]', closeWith: '[/size]' },
			    { name: 'Normal', openWith: '[size=11px]', closeWith: '[/size]' },
			    { name: 'Pequeno', openWith: '[size=5px]', closeWith: '[/size]' }]
		  },

  		{separator: '---------------' },

    { name: 'Citar', openWith: '[quote]', closeWith: '[/quote]' },

    { separator: '---------------' },

		  { name: 'Alinhar à esquerda', openWith: '[left]', closeWith: '[/left]' },
		  { name: 'Centralizar', openWith: '[center]', closeWith: '[/center]' },
		  { name: 'Alinhar à direita', openWith: '[right]', closeWith: '[/right]' },
		  { name: 'Justificar', openWith: '[justify]', closeWith: '[/justify]' },

  		{separator: '---------------' },

    { name: 'Remova a formatação do texto selecionado', className: "clean", replaceWith: function (markitup) { return markitup.selection.replace(/\[(.*?)\]/g, "") } },
    { name: 'Fale com o mestre', openWith: '[master]', closeWith: '[/master]' },
    { name: 'Emoticons', dropMenu: [
			    { name: ':arrow:',   openWith: ':arrow: ', className: 'icon-arrow' },
			    { name: ':D', openWith: ':D ', className: 'icon-biggrin' },
			    { name: ':?:', openWith: ':?: ', className: 'icon-question' },
			    { name: ':?', openWith: ':? ', className: 'icon-confused' },
			    { name: '8)', openWith: '8) ', className: 'icon-cool' },
			    { name: ':cry:', openWith: ':cry: ', className: 'icon-cry' },
			    { name: ':shock:', openWith: ':shock: ', className: 'icon-eek' },
			    { name: ':evil:', openWith: ':evil: ', className: 'icon-evil' },
			    { name: ':!:', openWith: ':!: ', className: 'icon-exclaim' },
			    { name: ':idea:', openWith: ':idea: ', className: 'icon-idea' },
			    { name: ':lol:', openWith: ':lol: ', className: 'icon-lol' },
			    { name: ':x', openWith: ':x ', className: 'icon-mad' },
			    { name: ':mrgreen:', openWith: ':mrgreen: ', className: 'icon-mrgreen' },
			    { name: ':|', openWith: ':| ', className: 'icon-neutral' },
			    { name: ':P', openWith: ':P ', className: 'icon-razz' },
			    { name: ':oops:', openWith: ':oops: ', className: 'icon-redface' },
			    { name: ':roll:', openWith: ':roll: ', className: 'icon-rolleyes' },
			    { name: ':(', openWith: ':( ', className: 'icon-sad' },
			    { name: ':)', openWith: ':) ', className: 'icon-smile' },
			    { name: ':o', openWith: ':o ', className: 'icon-surprised' },
			    { name: ':twisted:', openWith: ':twisted: ', className: 'icon-twisted' },
			    { name: ':wink:', openWith: ':wink: ', className: 'icon-wink' }
		    ]
    },
    { name: 'Spoiler', openWith: '[spoiler=[![Texto]!]]', closeWith: '[/spoiler]', placeHolder: 'Conteúdo com spoiler aqui...' },
    { name: 'Destaque de texto', openWith: '[kbd]', closeWith: '[/kbd]' },
	]
}

var simpleSettings = {
  markupSet: [
		  { name: 'Negrito', openWith: '[b]', closeWith: '[/b]' },
		  { name: 'Itálico', openWith: '[i]', closeWith: '[/i]' },
		  { name: 'Sublinhado', openWith: '[u]', closeWith: '[/u]' },
		  { name: 'Tachado', openWith: '[s]', closeWith: '[/s]' },
		  { separator: '---------------' },
		  { name: 'Imagem', replaceWith: '[img][![Url]!][/img]' },
		  { name: 'Link', openWith: '[url=[![Url]!]]', closeWith: '[/url]', placeHolder: 'Your text to link here...' },
		  { separator: '---------------' },
		  { name: 'Cores', openWith: '[color=[![Color]!]]', closeWith: '[/color]', dropMenu: [
          { name: 'Preto', openWith: '[color=#000]', closeWith: '[/color]', className: "black" },
          { name: "Foquete", openWith: '[color=#800000]', closeWith: '[/color]', className: "foquete" },
          { name: "Marrom 1", openWith: '[color=#8B4513]', closeWith: '[/color]', className: "marrom1" },
          { name: "Cinza 1", openWith: '[color=#2F4F4F]', closeWith: '[/color]', className: "cinza1" },
          { name: "Cerceta", openWith: '[color=#008080]', closeWith: '[/color]', className: "cerceta" },
          { name: "Azul Marinho", openWith: '[color=#000080]', closeWith: '[/color]', className: "azul-marinho" },
          { name: "Índigo", openWith: '[color=#4B0082]', closeWith: '[/color]', className: "indigo" },
          { name: "Cinza 2", openWith: '[color=#696969]', closeWith: '[/color]', className: "cinza2" },

          { name: "Tijolo de Fogo", openWith: '[color=#B22222]', closeWith: '[/color]', className: "tijolo-de-fogo" },
          { name: "Marrom 2", openWith: '[color=#A52A2A]', closeWith: '[/color]', className: "marrom2" },
          { name: "Vara Dourada", openWith: '[color=#DAA520]', closeWith: '[/color]', className: "vara-dourada" },
          { name: "Verde Escuro", openWith: '[color=#006400]', closeWith: '[/color]', className: "verde-escuro" },
          { name: "Turquesa", openWith: '[color=#40E0D0]', closeWith: '[/color]', className: "turqueza" },
          { name: "Azul Médio", openWith: '[color=#0000CD]', closeWith: '[/color]', className: "azul-medio" },
          { name: 'Roxo', openWith: '[color=purple]', closeWith: '[/color]', className: "purple" },
          { name: "Cinza 3", openWith: '[color=#808080]', closeWith: '[/color]', className: "cinza3" },

          { name: 'Vermelho', openWith: '[color=red]', closeWith: '[/color]', className: "red" },
          { name: "Laranja Escuro", openWith: '[color=#FF8C00]', closeWith: '[/color]', className: "laranja-escuro" },
          { name: "Dourado", openWith: '[color=#FFD700]', closeWith: '[/color]', className: "dourado" },
          { name: 'Verde', openWith: '[color=green]', closeWith: '[/color]', className: "green" },
          { name: "Ciano", openWith: '[color=#00FFFF]', closeWith: '[/color]', className: "ciano" },
          { name: 'Azul', openWith: '[color=blue]', closeWith: '[/color]', className: "blue" },
          { name: "Violeta", openWith: '[color=#EE82EE]', closeWith: '[/color]', className: "violeta" },
          { name: "Cinza Escuro", openWith: '[color=#A9A9A9]', closeWith: '[/color]', className: "cinza-escuro" },

          { name: "Salmão Claro", openWith: '[color=#FFA07A]', closeWith: '[/color]', className: "salmao-claro" },
		        { name: 'Laranja', openWith: '[color=orange]', closeWith: '[/color]', className: "orange" },
          { name: 'Amarelo', openWith: '[color=yellow]', closeWith: '[/color]', className: "yellow" },
          { name: "Lima", openWith: '[color=#00FF00]', closeWith: '[/color]', className: "lima" },
          { name: "Turquesa Pálido", openWith: '[color=#AFEEEE]', closeWith: '[/color]', className: "turqueza-palido" },
          { name: "Azul Claro", openWith: '[color=#ADD8E6]', closeWith: '[/color]', className: "azul-claro" },
          { name: "Ameixa", openWith: '[color=#DDA0DD]', closeWith: '[/color]', className: "ameixa" },
          { name: "Cinza Claro", openWith: '[color=#D3D3D3]', closeWith: '[/color]', className: "cinza-claro" },

          { name: "Lavanda 1", openWith: '[color=#FFF0F5]', closeWith: '[/color]', className: "lavanda1" },
          { name: "Branco Antiguidade", openWith: '[color=#FAEBD7]', closeWith: '[/color]', className: "branco-antiguidade" },
          { name: "Amarelo Claro", openWith: '[color=#FFFFE0]', closeWith: '[/color]', className: "amarelo-claro" },
          { name: "Orvalho", openWith: '[color=#F0FFF0]', closeWith: '[/color]', className: "orvalho" },
          { name: "Azure", openWith: '[color=#F0FFFF]', closeWith: '[/color]', className: "azure" },
          { name: "Azul Alice", openWith: '[color=#F0F8FF]', closeWith: '[/color]', className: "azul-alice" },
          { name: "Lavanda 2", openWith: '[color=#E6E6FA]', closeWith: '[/color]', className: "lavanda2" },
          { name: 'Branco', openWith: '[color=white]', closeWith: '[/color]', className: "white" }]
	 	 },

		  { name: 'Tamanho', openWith: '[size=[![Text size]!]]', closeWith: '[/size]', dropMenu: [
			    { name: 'Grande', openWith: '[size=25px]', closeWith: '[/size]' },
			    { name: 'Normal', openWith: '[size=11px]', closeWith: '[/size]' },
			    { name: 'Pequeno', openWith: '[size=5px]', closeWith: '[/size]' }]
		  },

		  {separator: '---------------' },
		  { name: 'Citar', openWith: '[quote]', closeWith: '[/quote]' },
		  {separator: '---------------' },
		  { name: 'Alinhar à esquerda', openWith: '[left]', closeWith: '[/left]' },
		  { name: 'Centralizar', openWith: '[center]', closeWith: '[/center]' },
		  { name: 'Alinhar à direita', openWith: '[right]', closeWith: '[/right]' },
		  { name: 'Justificar', openWith: '[justify]', closeWith: '[/justify]' },
    { name: 'Emoticons', dropMenu: [
			    { name: ':arrow:', openWith: ':arrow: ', className: 'icon-arrow' },
			    { name: ':D', openWith: ':D ', className: 'icon-biggrin' },
			    { name: ':?:', openWith: ':?: ', className: 'icon-question' },
			    { name: ':?', openWith: ':? ', className: 'icon-confused' },
			    { name: '8)', openWith: '8) ', className: 'icon-cool' },
			    { name: ':cry:', openWith: ':cry: ', className: 'icon-cry' },
			    { name: ':shock:', openWith: ':shock: ', className: 'icon-eek' },
			    { name: ':evil:', openWith: ':evil: ', className: 'icon-evil' },
			    { name: ':!:', openWith: ':!: ', className: 'icon-exclaim' },
			    { name: ':idea:', openWith: ':idea: ', className: 'icon-idea' },
			    { name: ':lol:', openWith: ':lol: ', className: 'icon-lol' },
			    { name: ':x', openWith: ':x ', className: 'icon-mad' },
			    { name: ':mrgreen:', openWith: ':mrgreen: ', className: 'icon-mrgreen' },
			    { name: ':|', openWith: ':| ', className: 'icon-neutral' },
			    { name: ':P', openWith: ':P ', className: 'icon-razz' },
			    { name: ':oops:', openWith: ':oops: ', className: 'icon-redface' },
			    { name: ':roll:', openWith: ':roll: ', className: 'icon-rolleyes' },
			    { name: ':(', openWith: ':( ', className: 'icon-sad' },
			    { name: ':)', openWith: ':) ', className: 'icon-smile' },
			    { name: ':o', openWith: ':o ', className: 'icon-surprised' },
			    { name: ':twisted:', openWith: ':twisted: ', className: 'icon-twisted' },
			    { name: ':wink:', openWith: ':wink: ', className: 'icon-wink' }
		    ]
    }
	 ]
}
