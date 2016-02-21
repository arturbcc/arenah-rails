# frozen_string_literal: true

require 'rails_helper'

describe Sheet::TableItem do
  let(:table) { @system.tables.first }

  before(:all) do
    @system = load_system
  end

  it 'serializes the 1st item on table `Carregar`' do
    item = table.table_items.first
    expect(item.key).to eq('1')
    expect(item.value).to eq(15)
  end

  it 'serializes the 2st item on table `Carregar`' do
    item = table.table_items[1]
    expect(item.key).to eq('2')
    expect(item.value).to eq(15)
  end

  it 'serializes the 3st item on table `Carregar`' do
    item = table.table_items[2]
    expect(item.key).to eq('3')
    expect(item.value).to eq(20)
  end
end
