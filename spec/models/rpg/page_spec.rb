require 'rails_helper'

describe RPG::Page do
  before(:all) do
    load_system
  end

  it 'put numbers on each page' do
    expect(@system.sheet.pages.map(&:number)).to eq([1, 2, 3])
  end

  it 'saves the numbers of columns on each page' do
    expect(@system.sheet.pages.map(&:number_of_columns)).to eq([2, 2, 1])
  end

  it 'shows header on the first page' do
    expect(@system.sheet.pages.first.show_header?).to be_truthy
  end

  it 'does not show header on the second page' do
    expect(@system.sheet.pages[1].show_header?).to be_falsy
  end

  it 'does not show header on the last page' do
    expect(@system.sheet.pages.last.show_header?).to be_falsy
  end
end
