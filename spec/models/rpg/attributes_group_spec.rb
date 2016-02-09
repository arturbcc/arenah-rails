require 'rails_helper'

describe RPG::AttributesGroup do
  before(:all) do
    load_system
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
    expect(group.instructions).not_to be_empty
  end
end
