# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::CharacterAttribute, type: :model do
  context 'Game System' do
    before(:all) do
      @system = load_system
    end

    describe 'Dados' do
      before do
        @group = @system.sheet.find_attributes_group('Dados')
      end

      it 'serializes the attribute `Nome`' do
        attributes = @group.character_attributes.first

        expect(attributes.name).to eq('Nome')
        expect(attributes.description).not_to be_blank
        expect(attributes.order).to eq(1)
      end

      it 'serializes the attribute `Nascimento`' do
        attributes = @group.character_attributes[1]

        expect(attributes.name).to eq('Nascimento')
        expect(attributes.description).not_to be_blank
        expect(attributes.order).to eq(2)
      end

      it 'serializes the attribute `Local`' do
        attributes = @group.character_attributes[2]

        expect(attributes.name).to eq('Local')
        expect(attributes.description).not_to be_blank
        expect(attributes.order).to eq(3)
      end

      it 'serializes the attribute `Sexo`' do
        attributes = @group.character_attributes[3]

        expect(attributes.name).to eq('Sexo')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(4)
      end

      it 'serializes the attribute `Altura`' do
        attributes = @group.character_attributes[4]

        expect(attributes.name).to eq('Altura')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(5)
      end

      it 'serializes the attribute `Peso`' do
        attributes = @group.character_attributes[5]

        expect(attributes.name).to eq('Peso')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(6)
      end

      it 'serializes the attribute `Classe`' do
        attributes = @group.character_attributes[6]

        expect(attributes.name).to eq('Classe')
        expect(attributes.description).not_to be_blank
        expect(attributes.order).to eq(7)
      end

      it 'serializes the attribute `Nível`' do
        attributes = @group.character_attributes[7]

        expect(attributes.name).to eq('Nível')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(8)
      end

      it 'serializes the attribute `Idiomas`' do
        attributes = @group.character_attributes[8]

        expect(attributes.name).to eq('Idiomas')
        expect(attributes.description).not_to be_blank
        expect(attributes.order).to eq(9)
      end

      it 'serializes the attribute `Raça`' do
        attributes = @group.character_attributes[9]

        expect(attributes.name).to eq('Raça')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(10)
      end

      it 'serializes the attribute `Idade`' do
        attributes = @group.character_attributes[10]

        expect(attributes.name).to eq('Idade')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(11)
      end

      it 'serializes the attribute `Religião`' do
        attributes = @group.character_attributes[11]

        expect(attributes.name).to eq('Religião')
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(12)
      end

    end

    describe 'Atributos' do
      before do
        @group = @system.sheet.find_attributes_group('Atributos')
      end

      it 'serializes the attribute `Força`' do
        attributes = @group.character_attributes.first

        expect(attributes.name).to eq('Força')
        expect(attributes.abbreviation).to eq('Fr')
        expect(attributes.order).to eq(1)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Constituição`' do
        attributes = @group.character_attributes[1]

        expect(attributes.name).to eq('Constituição')
        expect(attributes.abbreviation).to eq('Con')
        expect(attributes.order).to eq(2)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Destreza`' do
        attributes = @group.character_attributes[2]

        expect(attributes.name).to eq('Destreza')
        expect(attributes.abbreviation).to eq('Dex')
        expect(attributes.order).to eq(3)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Agilidade`' do
        attributes = @group.character_attributes[3]

        expect(attributes.name).to eq('Agilidade')
        expect(attributes.abbreviation).to eq('Agi')
        expect(attributes.order).to eq(4)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Inteligência`' do
        attributes = @group.character_attributes[4]

        expect(attributes.name).to eq('Inteligência')
        expect(attributes.abbreviation).to eq('Int')
        expect(attributes.order).to eq(5)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Força de vontade`' do
        attributes = @group.character_attributes[5]

        expect(attributes.name).to eq('Força de vontade')
        expect(attributes.abbreviation).to eq('Will')
        expect(attributes.order).to eq(6)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Percepção`' do
        attributes = @group.character_attributes[6]

        expect(attributes.name).to eq('Percepção')
        expect(attributes.abbreviation).to eq('Per')
        expect(attributes.order).to eq(7)
        expect(attributes.description).not_to be_blank
      end

      it 'serializes the attribute `Carisma`' do
        attributes = @group.character_attributes[7]

        expect(attributes.name).to eq('Carisma')
        expect(attributes.abbreviation).to eq('Car')
        expect(attributes.order).to eq(8)
        expect(attributes.description).not_to be_blank
      end
    end

    describe 'Dados Extras' do
      before do
        @group = @system.sheet.find_attributes_group('Dados Extras')
      end

      it 'serializes the attribute `Carregar`' do
        attributes = @group.character_attributes.first

        expect(attributes.name).to eq('Carregar')
        expect(attributes.base_attribute_group).to eq('Atributos')
        expect(attributes.base_attribute_name).to eq('Força')
        expect(attributes.abbreviation).to be_blank
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(1)
        expect(attributes.table_name).to eq('Carregar')
      end

      it 'serializes the attribute `Levantar`' do
        attributes = @group.character_attributes[1]

        expect(attributes.name).to eq('Levantar')
        expect(attributes.base_attribute_group).to eq('Atributos')
        expect(attributes.base_attribute_name).to eq('Força')
        expect(attributes.abbreviation).to be_blank
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(2)
        expect(attributes.table_name).to eq('Levantar')
      end

      it 'serializes the attribute `Velocidade`' do
        attributes = @group.character_attributes[2]

        expect(attributes.name).to eq('Velocidade')
        expect(attributes.base_attribute_group).to eq('Atributos')
        expect(attributes.base_attribute_name).to eq('Agilidade')
        expect(attributes.abbreviation).to be_blank
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(3)
        expect(attributes.table_name).to eq('Velocidade')
      end

      it 'serializes the attribute `Bônus de dano`' do
        attributes = @group.character_attributes[3]

        expect(attributes.name).to eq('Bônus de dano')
        expect(attributes.base_attribute_group).to eq('Atributos')
        expect(attributes.base_attribute_name).to eq('Força')
        expect(attributes.abbreviation).to be_blank
        expect(attributes.description).to be_blank
        expect(attributes.order).to eq(4)
        expect(attributes.table_name).to eq('Bônus de dano')
      end
    end
  end

  context 'Character Sheet' do
    before(:all) do
      @sheet = load_sheet('crossover', 'inuyasha')
    end

    it 'serializes the group "Dados"' do
      group_name = 'Dados'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(12)

      expected = [
        { name: 'Nome', content: 'Inuyasha' },
        { name: 'Nascimento', content: 'Desconhecido' },
        { name: 'Local', content: 'Era Feudal' },
        { name: 'Sexo', content: 'Masculino' },
        { name: 'Altura', content: '1,70m' },
        { name: 'Peso', content: '75kg' },
        { name: 'Classe', content: 'Guerreiro' },
        { name: 'Nível', content: '1' },
        { name: 'Idiomas', content: 'Padrão' },
        { name: 'Raça', content: 'Meio Youkai' },
        { name: 'Idade', content: '25' },
        { name: 'Religião', content: '--' }
      ]

      attributes = get_attributes(group.character_attributes, :name, :content)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Dados Extras"' do
      group_name = 'Dados Extras'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(4)
    end

    it 'serializes the group "Atributos"' do
      group_name = 'Atributos'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(8)

      expected = [
        { name: 'Força', points: 10  },
        { name: 'Constituição', points: 12 },
        { name: 'Destreza', points: 7 },
        { name: 'Agilidade', points: 5 },
        { name: 'Inteligência', points: 17 },
        { name: 'Força de vontade', points: 21 },
        { name: 'Percepção', points: 12 },
        { name: 'Carisma', points: 10 }
      ]

      attributes = get_attributes(group.character_attributes, :name, :points)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Perícias"' do
      group_name = 'Perícias'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(14)

      expected = [
        { name: 'História', points: 10 },
        { name: 'Heráldica', points: 12 },
        { name: 'Natação', points: 27 },
        { name: 'Sedução', points: 35 },
        { name: 'Lábia', points: 37 },
        { name: 'Manha', points: 10 },
        { name: 'Montaria - cavalo', points: 10 },
        { name: 'Prestidigitação', points: 12 },
        { name: 'Geografia', points: 10 },
        { name: 'Herbalismo', points: 12 },
        { name: 'Ler/Escrever', points: 27 },
        { name: 'Espada curta', points: 35 },
        { name: 'Espada longa', points: 37 },
        { name: 'Saltos', points: 10 }
      ]

      attributes = get_attributes(group.character_attributes, :name, :points)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Aprimoramentos"' do
      group_name = 'Aprimoramentos'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(5)

      expected = [
        { name: 'Sensitivo' },
        { name: 'Poderes mágicos' },
        { name: 'Presença invisível' },
        { name: 'Inimigo' },
        { name: 'Má fama' }
      ]

      attributes = get_attributes(group.character_attributes, :name)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Itens"' do
      group_name = 'Itens'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(9)

      expected = [
        { name: 'Faca' },
        { name: 'Mochila' },
        { name: 'Algibeira' },
        { name: 'Barraca' },
        { name: 'Cantil' },
        { name: 'Pergaminho' },
        { name: 'Pena' },
        { name: 'Tinteiro' },
        { name: 'Caneca' }
      ]

      attributes = get_attributes(group.character_attributes, :name)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "História"' do
      group_name = 'História'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(1)

      expected = [
        {
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.' +
            ' In consectetur metus quis cursus semper. Morbi ac pharetra lorem.' +
            ' Phasellus non congue dolor. Mauris molestie malesuada porta. Cras' +
            ' in tempor ex, sed interdum nisi. Morbi ultrices sed diam ut' +
            ' porttitor. Integer et tortor erat. Nam malesuada pharetra odio' +
            ' sed pharetra. Morbi ullamcorper nibh mi, egestas ullamcorper' +
            ' ipsum cursus vitae. Phasellus blandit dolor nec quam aliquam, vel' +
            ' fermentum massa dignissim. Duis ut justo eu diam euismod' +
            ' fringilla. Proin iaculis lectus at dolor placerat blandit.' +
            ' Phasellus bibendum faucibus posuere. Fusce et justo vel erat' +
            ' mollis tempor nec in quam. Aenean non tristique orci. Suspendisse' +
            ' imperdiet volutpat magna, sit amet euismod est blandit a. Mauris' +
            ' eu velit id nibh faucibus lobortis ut ac dolor. Duis faucibus' +
            ' nulla metus, in lacinia felis molestie semper. Nullam ac aliquet' +
            ' turpis, a lacinia nulla. Suspendisse id leo a dolor consequat' +
            ' congue. Aliquam in orci augue. Praesent ac fringilla lectus. Ut' +
            ' finibus lacus ut risus tempor, sed auctor risus auctor. Phasellus' +
            ' iaculis metus a ligula cursus porta. Donec dignissim commodo' +
            ' posuere. Ut aliquam dui id nisi fringilla, ut malesuada felis' +
            ' ultricies. Duis sed rhoncus libero, non euismod urna. Vivamus' +
            ' fermentum fringilla velit id finibus. Donec et urna convallis,' +
            ' commodo ligula porta, euismod est. Integer a sem pulvinar,' +
            ' sagittis nunc ac, facilisis massa. Vivamus mi odio, iaculis' +
            ' eget cursus eget, posuere eget nisl. In imperdiet tempor tellus' +
            ' id egestas. Quisque venenatis nunc quis erat volutpat, sit amet' +
            ' egestas eros feugiat. Nam ante dolor, porttitor nec ante et,' +
            ' maximus ullamcorper tellus. Vivamus scelerisque hendrerit mi ac' +
            ' placerat. Proin at metus augue. Proin tristique maximus lacus,' +
            ' non molestie odio pretium at. Morbi nisl risus, vehicula quis arcu' +
            ' tincidunt, dapibus ornare justo. Nullam commodo ex sit amet leo' +
            ' pulvinar, in hendrerit elit auctor. Duis placerat odio quis' +
            ' ullamcorper vulputate. Donec sollicitudin interdum augue egestas' +
            ' laoreet. Morbi vel nulla ipsum. Nullam euismod pretium est,' +
            ' vehicula vestibulum metus. Quisque eleifend sem lacus, fringilla' +
            ' lacinia mauris dictum ac. Curabitur imperdiet magna ligula, ut' +
            ' porttitor diam ullamcorper et.'
          },
      ]

      attributes = get_attributes(group.character_attributes, :content)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Status"' do
      group_name = 'Status'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(6)

      expected = [
        { name: 'Vida', points: 49 },
        { name: 'Magia', points: 9  },
        { name: 'XP', points: 2636 },
        { name: 'PH', points: 10 },
        { name: 'Recursos', points: 1252 },
        { name: 'Anime', content: 'Inuyasha' }
      ]

      attributes = get_attributes(group.character_attributes, :name, :points, :total, :content)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Grimório"' do
      group_name = 'Grimório'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.character_attributes.count).to eq(1)

      expected = [
        { name: 'Transformação em Youkai completo' }
      ]

      attributes = get_attributes(group.character_attributes, :name)
      expect(attributes).to eq(expected)
    end

    it 'serializes the group "Equipamentos"' do
      group_name = 'Equipamentos'
      group = @sheet.find_attributes_group(group_name)
      expect(group.name).to eq(group_name)
      expect(group.equipments.count).to eq(2)

      expected = [
        { name: 'Tessaiga', equipped_on: 'right-hand' },
        { name: 'Kimono', equipped_on: 'chest' }
      ]

      attributes = get_attributes(group.equipments, :name, :equipped_on)
      expect(attributes).to eq(expected)
    end
  end

  describe '#to_params' do
    context 'with base attribute' do
      let(:base_attribute) do
        Sheet::CharacterAttribute.new(name: 'Agilidade', points: '10')
      end

      let(:attribute) do
        Sheet::CharacterAttribute.new(
          name: 'Natação',
          base_attribute_group: 'Atributos',
          base_attribute_name: 'Agilidade',
          points: 30,
          formula: '1D100',
          order: 1
        )
      end

      it 'transforms the attribute in a hash params' do
        attribute.base_attribute = base_attribute

        expected = {
          base_attribute_group: 'Atributos',
          base_attribute_name: 'Agilidade',
          attribute_name: 'Natação',
          points: 30,
          value: 40
        }
        expect(attribute.to_params).to eq(expected)
      end
    end

    context 'without base attribute' do
      it 'transforms the attribute in a hash params' do
        expected = {
          attribute_name: 'Natação',
          points: nil,
          value: 0
        }
        attribute = Sheet::CharacterAttribute.new(name: 'Natação')
        expect(attribute.to_params).to eq(expected)
      end
    end
  end

  describe '#to_s' do
    it 'prints the points and the value of the attribute' do
      expect(Sheet::CharacterAttribute.new(points: 10, cost: 30).to_s).to eq('10 / 30')
    end
  end

  private

  def get_attributes(list, *keys)
    list.map do |attribute|
      hash = {}
      keys.each do |key|
        value = attribute.public_send(key)
        hash[key] = value if value.present?
      end

      hash
    end
  end
end
