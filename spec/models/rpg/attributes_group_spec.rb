require 'rails_helper'

describe RPG::AttributesGroup do
  context 'Game System' do
    before(:all) do
      @system = load_system
    end

    it 'serializes the group "Dados"' do
      group = @system.sheet.attributes_groups.first

      expect(group.name).to eq('Dados')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('character_card')
      expect(group.position).to eq('header')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).not_to be_blank
      expect(group.character_attributes.count).to eq(12)
    end

    it 'serializes the group "Dados Extras"' do
      group = @system.sheet.attributes_groups[1]

      expect(group.name).to eq('Dados Extras')
      expect(group.page).to eq(1)
      expect(group.order).to eq(2)
      expect(group.type).to eq('table')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('table')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(4)
    end

    it 'serializes the group "Atributos"' do
      group = @system.sheet.attributes_groups[2]

      expect(group.name).to eq('Atributos')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('name_value')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be_truthy
      expect(group.order_on_posts).to eq(1)
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to eq('4 * points')
      expect(group.group_points_formula).to eq('100 + #{Dados:Nível}')
      expect(group.character_attributes.count).to eq(8)
    end

    it 'serializes the group "Perícias"' do
      group = @system.sheet.attributes_groups[3]

      expect(group.name).to eq('Perícias')
      expect(group.page).to eq(1)
      expect(group.order).to eq(1)
      expect(group.type).to eq('based')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.group_points_formula).to eq('10 * #{Dados:Idade} + 5 * #{Atributos:Inteligência}')
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(14)
    end

    it 'serializes the group "Aprimoramentos"' do
      group = @system.sheet.attributes_groups[4]

      expect(group.name).to eq('Aprimoramentos')
      expect(group.page).to eq(1)
      expect(group.order).to eq(2)
      expect(group.type).to eq('name_value')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).not_to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.group_points_formula).to eq('5 + floor(#{Dados:Nível} / 3)')
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(13)
    end

    it 'serializes the group "Itens"' do
      group = @system.sheet.attributes_groups[5]

      expect(group.name).to eq('Itens')
      expect(group.page).to eq(2)
      expect(group.order).to eq(1)
      expect(group.type).to eq('text')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('open')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).to be_blank
      expect(group.attributes_points_formula).to be_nil
      expect(group.character_attributes.count).to eq(0)
    end

    it 'serializes the group "História"' do
      group = @system.sheet.attributes_groups[6]

      expect(group.name).to eq('História')
      expect(group.page).to eq(3)
      expect(group.order).to eq(1)
      expect(group.type).to eq('rich_text')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('open')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).not_to be_blank
      expect(group.character_attributes).to be_nil
    end

    it 'serializes the group "Status"' do
      group = @system.sheet.attributes_groups[7]

      expect(group.name).to eq('Status')
      expect(group.page).to eq(1)
      expect(group.order).to eq(3)
      expect(group.type).to eq('mixed')
      expect(group.position).to eq('column_1')
      expect(group.source_type).to eq('fixed')
      expect(group.show_on_posts?).to be_truthy
      expect(group.order_on_posts).to eq(1)
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(6)
    end

    it 'serializes the group "Grimório"' do
      group = @system.sheet.attributes_groups[8]

      expect(group.name).to eq('Grimório')
      expect(group.page).to eq(2)
      expect(group.order).to eq(2)
      expect(group.type).to eq('text')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('list')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).to be_blank
      expect(group.character_attributes.count).to eq(0)
      expect(group.list.count).to eq(7)
    end

    it 'serializes the group "Equipamentos"' do
      group = @system.sheet.attributes_groups.last

      expect(group.name).to eq('Equipamentos')
      expect(group.page).to eq(2)
      expect(group.order).to eq(1)
      expect(group.type).to eq('equipments')
      expect(group.position).to eq('column_2')
      expect(group.source_type).to eq('equipments')
      expect(group.show_on_posts?).to be_falsy
      expect(group.instructions).to be_blank
      expect(group.character_attributes).to be_nil
      expect(group.equipments.count).to eq(11)
    end
  end

  context 'Character Sheet' do
    before(:all) do
      @sheet = load_sheet('crossover', 'inuyasha')
    end

    it 'serializes the equipments' do
      expect(@sheet.attributes_groups.count).to eq(10)
    end
  end
end
