# frozen_string_literal: true

require 'rails_helper'

describe Sheet::Table do
  before(:all) do
    @system = load_system
  end

  it 'serializes the table `Carregar`' do
    table = @system.tables.first
    expect(table.name).to eq('Carregar')
    expect(table.unit).to eq('kg')
    expect(table.table_items.count).to eq(61)
  end

  it 'serializes the table `Levantar`' do
    table = @system.tables[1]
    expect(table.name).to eq('Levantar')
    expect(table.unit).to eq('kg')
    expect(table.table_items.count).to eq(61)
  end

  it 'serializes the table `Bônus de dano`' do
    table = @system.tables[2]
    expect(table.name).to eq('Bônus de dano')
    expect(table.unit).to be_blank
    expect(table.table_items.count).to eq(61)
  end

  it 'serializes the table `Velocidade`' do
    table = @system.tables[3]
    expect(table.name).to eq('Velocidade')
    expect(table.unit).to eq('m/s')
    expect(table.table_items.count).to eq(61)
  end
end
