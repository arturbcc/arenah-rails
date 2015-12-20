require 'rails_helper'

describe GameHelper do
  describe '#banner' do
    context 'with banner' do
      let(:game) { build(:game, banner: 'resident-evil.png') }

      it 'renders the game\'s banner with a link to the game' do
        expect(helper.banner(game)).to include(game.banner)
      end
    end

    context 'without banner' do
      let(:game) { build(:game) }

      it 'renders the default banner with a link to the game' do
        expect(helper.banner(game)).to include('defaults/banner.jpg')
      end
    end
  end

  describe '#custom' do
    context 'with game' do
      let(:game) { build(:game) }

      it 'renders the game\'s custom css' do
        expect(helper.custom_css(game)).to include('css/custom.css')
      end
    end

    context 'without game' do
      it 'returns nil' do
        expect(helper.custom_css(nil)).to be_nil
      end
    end
  end

  describe '#menu_item' do
    let(:area) { Area.new }

    it 'includes an icon' do
      menu_item = helper.menu_item(area, icon: 'home')
      expect(menu_item).to include('<i class="fa fa-home"></i>')
    end

    it 'includes a title' do
      menu_item = helper.menu_item(area, title: 'Title')
      expect(menu_item).to include('<strong>Title</strong>')
    end

    it 'includes a subtitle' do
      menu_item = helper.menu_item(area, subtitle: 'Subtitle')
      expect(menu_item).to include('<small>Subtitle</small>')
    end

    it 'includes a li element' do
      menu_item = helper.menu_item(area)
      expect(menu_item).to include('<li>')
    end

    it 'marks the link as active' do
      menu_item = helper.menu_item(Area.new(:home), area: :home)
      expect(menu_item).to include('class="active"')
    end

    it 'does not mark the link as active' do
      menu_item = helper.menu_item(Area.new(:home), area: :inscription)
      expect(menu_item).not_to include('class="active"')
    end
  end
end
