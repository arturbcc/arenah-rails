# frozen_string_literal: true

require 'rails_helper'

describe Sheet::List do
  before(:all) do
    @system = load_system
  end

  describe 'Perícias' do
    before do
      @list = @system.sheet.find_attributes_group('Perícias').list
    end

    it 'serializes the list item `História`' do
      list_item = @list.first
      expect(list_item.name).to eq('História')
      expect(list_item.description).not_to be_blank
    end

    it 'serializes the list item `Heráldica`' do
      list_item = @list[1]
      expect(list_item.name).to eq('Heráldica')
      expect(list_item.description).not_to be_blank
    end

    it 'serializes the list item `Natação`' do
      list_item = @list[2]
      expect(list_item.name).to eq('Natação')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Agilidade')
    end

    it 'serializes the list item `Sedução`' do
      list_item = @list[3]
      expect(list_item.name).to eq('Sedução')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Carisma')
    end

    it 'serializes the list item `Lábia`' do
      list_item = @list[4]
      expect(list_item.name).to eq('Lábia')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Carisma')
    end

    it 'serializes the list item `Manha`' do
      list_item = @list[5]
      expect(list_item.name).to eq('Manha')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Carisma')
    end

    it 'serializes the list item `Montaria - cavalo`' do
      list_item = @list[6]
      expect(list_item.name).to eq('Montaria - cavalo')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Agilidade')
    end

    it 'serializes the list item `Prestidigitação`' do
      list_item = @list[7]
      expect(list_item.name).to eq('Prestidigitação')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Destreza')
    end

    it 'serializes the list item `Geografia`' do
      list_item = @list[8]
      expect(list_item.name).to eq('Geografia')
      expect(list_item.description).not_to be_blank
    end

    it 'serializes the list item `Herbalismo`' do
      list_item = @list[9]
      expect(list_item.name).to eq('Herbalismo')
      expect(list_item.description).not_to be_blank
    end

    it 'serializes the list item `Ler/Escrever`' do
      list_item = @list[10]
      expect(list_item.name).to eq('Ler/Escrever')
      expect(list_item.description).not_to be_blank
    end

    it 'serializes the list item `Espada curta`' do
      list_item = @list[11]
      expect(list_item.name).to eq('Espada curta')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Destreza')
    end

    it 'serializes the list item `Espada longa`' do
      list_item = @list[12]
      expect(list_item.name).to eq('Espada longa')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Destreza')
    end

    it 'serializes the list item `Saltos`' do
      list_item = @list.last
      expect(list_item.name).to eq('Saltos')
      expect(list_item.description).not_to be_blank
      expect(list_item.base_attribute_group).to eq('Atributos')
      expect(list_item.base_attribute_name).to eq('Agilidade')
    end
  end
end
