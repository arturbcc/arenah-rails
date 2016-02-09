require 'rails_helper'

describe RPG::CharacterAttribute do
  before(:all) do
    load_system
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
