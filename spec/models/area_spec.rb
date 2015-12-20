require 'rails_helper'

describe Area do
  describe '#profile?' do
    it 'is in profile area' do
      expect(Area.new(:profile)).to be_profile
    end

    it 'is not in profile area' do
      expect(Area.new).to_not be_profile
    end
  end

  describe '#panel?' do
    it 'is in the admin panel' do
      expect(Area.new(:panel)).to be_panel
    end

    it 'is in not the admin panel' do
      expect(Area.new).to_not be_panel
    end
  end

  describe '#current' do
    it 'shows the current area' do
      expect(Area.new(:home).current).to eq(:home)
    end
  end
end
