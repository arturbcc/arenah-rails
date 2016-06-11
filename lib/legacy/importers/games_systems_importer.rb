# frozen_string_literal: true

require 'legacy/importers/system_builder'
module Legacy
  module Importers
    class GamesSystemsImporter
      DATA = 0
      ATTRIBUTES = 1
      BACKGROUND = 2
      STATUS = 3

      def initialize(games, characters, sheets, sheet_attributes, sheet_data)
        @games = games
        @characters = characters
        @sheets = sheets
        @sheet_attributes = sheet_attributes
        @sheet_data = sheet_data
      end

      def import
        puts '12. Configuring RPG system'
        bar = RakeProgressbar.new(games.count)

        games.each do |game|
          bar.inc
          system_id = game.game_system_id.to_i

          game_system = attributes_for(game) do
            system_id != 2 ?
              arenah_attributes(game.forum_id) :
              daemon_attributes
          end

          if game.arenah_game
            game.arenah_game.update(system: game_system.to_json)
            game.system = game_system
          else
            puts "Cannot update game #{game.name}".red
          end
        end

        bar.finished
        puts ''

        replicate_sheet_to_characters
      end

      private

      def games
        @games.select { |game| game.root? }.sort_by { |game| game.name }
      end

      def attributes_for(game)
        game_system = Legacy::Importers::SystemBuilder.system.dup
        attributes = yield(game.forum_id)
        descriptions = daemon_descriptions

        return game_system unless attributes

        (1..10).each do |i|
          name = attributes["attribute#{i}".to_sym]

          next if name.nil? || name == 'NULL'
          game_system[:sheet][:attributes_groups][ATTRIBUTES][:character_attributes].push(
            {
              name: name,
              abbreviation: attributes["abbreviation#{i}".to_sym].to_s,
              order: i,
              description: game.game_system_id.to_i == 2 ? descriptions["attribute#{i}".to_sym].to_s : ''
            }
          )
        end

        game_system
      end

      def arenah_attributes(forum_id)
        @sheet_attributes.find { |attributes| attributes.forum_id == forum_id }
      end

      def daemon_attributes
        {
          attribute1: 'Força',
          attribute2: 'Constituição',
          attribute3: 'Destreza',
          attribute4: 'Agilidade',
          attribute5: 'Inteligência',
          attribute6: 'Força de vontade',
          attribute7: 'Percepção',
          attribute8: 'Carisma',
          abbreviation1: 'Fr',
          abbreviation2: 'Con',
          abbreviation3: 'Dex',
          abbreviation4: 'Agi',
          abbreviation5: 'Int',
          abbreviation6: 'Will',
          abbreviation7: 'Per',
          abbreviation8: 'Car'
        }
      end

      def daemon_descriptions
        {
          attribute1: '<p>Determina a força física do Personagem, sua capacidade muscular. A Força não tem tanta influência sobre a aparência quanto a Constituição — um lutador magrinho de karatê pode ser forte o bastante para quebrar pilhas de tijolos, mas um fisiculturista musculoso dificilmente poderia igualar a proeza.</p> <p>A Força, como a Constituição, tem influência sobre o cálculo dos Pontos de Vida. Quanto maior a FR, mais PVs um Personagem terá. A Força também afeta o dano que ele é capaz de causar com armas de combate corporal, e peso máximo que pode carregar ou sustentar (por poucos instantes).</p>',
          attribute2: 'Determina o vigor, saúde e condição física do Personagem. De modo geral, um Personagem com um baixo valor em Constituição é franzino e feio, enquanto um valor alto garante uma boa aparência — ou um aspecto de brutamontes, você decide. Isso não significa necessariamente que o Personagem seja forte ou fraco; isso é determinado pela Força. A Constituição determina a quantidade de Pontos de Vida — quanto mais alta a CON, mais PVs o Personagem terá. Também serve para testar a resistência a venenos, fadiga e rigores climáticos e físicos.',
          attribute3: 'Define a habilidade manual do Personagem, sua destreza com as mãos e/ou pés. Não inclui a agilidade corporal, apenas a destreza manual. Um Personagem com alta Destreza pode lidar melhor com armas, usar ferramentas, operar instrumentos delicados, atirar com arco-e-flecha, agarrar objetos em pleno ar...',
          attribute4: 'Ao contrário da Destreza, a Agilidade não é válida para coisas feitas com as mãos — mas sim para o corpo todo. Com um alto valor em Agilidade um Personagem pode correr mais rápido, equilibrar-se melhor sobre um muro, dançar com mais graça, esquivar-se de ataques... É importante fixar a diferença entre Destreza e Agilidade para fins de jogo.',
          attribute5: 'Inteligência é a capacidade de resolver problemas, nem mais e nem menos. Um Personagem inteligente está mais apto a compreender o que ocorre à sua volta e não se deixa enganar tão facilmente. Também lida com a memória, capacidade de abstrair conceitos e descobrir coisas novas.',
          attribute6: 'Esta é a capacidade de concentração e determinação do Personagem. Uma alta Força de Vontade fará com que um Personagem resista a coisas como tortura, hipnose, pânico, tentações e controle da mente. O Mestre também pode exigir Testes de Força de Vontade para verificar se um Personagem não fica apavorado diante de uma situação amedrontadora. Também está relacionada com a Magia e poderes psíquicos.',
          attribute7: 'É a capacidade de observar o mundo à volta e perceber detalhes importantes — como aquele cano de revólver aparecendo na curva do corredor. Um Personagem com alta Percepção está sempre atento a coisas estranhas e minúcias quase imperceptíveis, enquanto o sujeito com Percepção baixa é distraído e avoado.',
          attribute8: '<p>Determina o charme do Personagem, sua capacidade de fazer com que outras pessoas gostem dele. Um alto valor em Carisma não quer dizer que ele seja bonito ou coisa assim, apenas simpático: uma modelo profissional que tenha alta Constituição e baixo Carisma seria uma chata insuportável; um baixinho feio e mirrado, mas simpático, poderia reunir sem problemas montes de amigos à sua volta.</p> <p>O Carisma também define a Sorte de um Personagem. Não existe um Atributo Sorte, mas em situações complicadas, o Jogador pode pedir ao Mestre que Teste sua Sorte. Afinal de contas, pessoas de “alto astral” costumam ser mais afortunadas que os pessimistas resmungões.</p>'
        }
      end

      def replicate_sheet_to_characters
        puts 'Adding sheets on characters'
        bar = RakeProgressbar.new(@characters.count)

        @characters.each do |character|
          bar.inc
          game = games.find { |game| game.id == character.forum_id }

          if game.present?
            save_character_sheet(character, game)
          else
            puts "Could not find data for #{character.name} on #{game.try(:name)}".red
          end
        end
        bar.finished
        puts ''
      end

      def save_character_sheet(character, game)
        data = @sheet_data.find { |sheet_data| sheet_data.user_account_id == character.id }
        sheet = game.system.dup[:sheet][:attributes_groups]
        attributes = sheet[DATA][:character_attributes]

        attributes[0][:content] = character.name
        attributes[1][:content] = data.try(:xp) || 0
        attributes[2][:content] = ''
        attributes[3][:content] = data.try(:cash).to_i
        attributes[4][:content] = data.try(:level).to_i
        attributes[5][:content] = ''

        sheet_content = @sheets.find { |sheet| sheet.user_account_id == character.id }
        sheet[BACKGROUND][:character_attributes] = [{
          content: Parsers::Post.parse(sheet_content.try(:sheet).to_s)
        }]

        status = sheet[STATUS][:character_attributes]
        status[0][:total] = data.try(:total_life).to_i
        status[0][:points] = data.try(:life).to_i
        status[1][:total] = data.try(:total_mana).to_i
        status[1][:points] = data.try(:mana).to_i

        attributes = sheet[ATTRIBUTES][:character_attributes]
        (1..10).each do |index|
          attributes[index - 1][:points] = data.try(:public_send, "attribute#{index}").to_i
        end

        sheet = { attributes_groups: sheet }
        character.arenah_character.update(sheet: sheet.to_json)
      end
    end
  end
end
