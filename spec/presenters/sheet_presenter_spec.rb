require 'rails_helper'

RSpec.describe SheetPresenter, type: :presenter do
  describe '#system' do
    let(:user) { create(:user) }
    let(:system) { load_system }
    let(:character) { create(:character, user: user) }
    let(:game) { create(:game, system: system.to_json, character: character) }
    let(:sheet) { load_sheet('crossover', 'inuyasha') }
    let(:presenter) { described_class.new(character) }

    before do
      character.update(game: game)
    end

    it 'returns the system of the sheet' do
      expect(presenter.system.name).to eq(system.name)
    end

    it 'lists the pages of the sheet' do
      expect(presenter.pages.map(&:number)).to eq([1, 2, 3])
    end

    it 'lists the attributes on the header' do
      allow(character).to receive(:sheet).and_return(sheet)
      expect(presenter.header_attributes(page: 1).map(&:name)).to eq(['Dados'])
    end

    it 'lists the attributes on a column' do
      allow(character).to receive(:sheet).and_return(sheet)
      groups = presenter.column_attributes(page: 1, column: 1).map(&:name)
      expect(groups).to eq(%w(Atributos Aprimoramentos Status))
    end

    it 'lists the attributes on the footer' do
      allow(character).to receive(:sheet).and_return(sheet)
      groups = presenter.footer_attributes(page: 1).map(&:name)
      expect(groups).to be_empty
    end
  end
end
