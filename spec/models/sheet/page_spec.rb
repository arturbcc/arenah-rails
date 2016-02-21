# frozen_string_literal: true

require 'rails_helper'

describe Sheet::Page do
  before(:all) do
    @system = load_system
  end

  it 'put numbers on each page' do
    expect(@system.sheet.pages.map(&:number)).to eq([1, 2, 3])
  end

  it 'saves the numbers of columns on each page' do
    expect(@system.sheet.pages.map(&:number_of_columns)).to eq([2, 2, 1])
  end

  describe '#show_header?' do
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

  describe '#show_footer?' do
    it 'does not show footer on the first page' do
      expect(@system.sheet.pages.first.show_footer?).to be_falsy
    end

    it 'does not show footer on the second page' do
      expect(@system.sheet.pages[1].show_footer?).to be_falsy
    end

    it 'does not show footer on the last page' do
      expect(@system.sheet.pages.last.show_footer?).to be_falsy
    end

    it 'shows footer when show_footer is set to true' do
      page = Sheet::Page.new(show_footer: true)
      expect(page.show_footer?).to be_truthy
    end
  end
end
