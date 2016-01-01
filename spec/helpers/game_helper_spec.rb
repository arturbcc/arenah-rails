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

    context 'without a game' do
      it 'does not render the alt attribute' do
        expect(helper.banner).to include('alt=""')
      end
    end
  end

  describe '#banner_url' do
    context 'with game' do
      it 'returns the banner url of the game' do
        game = create(:game, banner: 'game_banner.png')
        expect(helper.banner_url(game)).to include(game.banner)
      end
    end

    context 'without game' do
      it 'returns the default banner' do
        expect(helper.banner_url).to include('defaults/banner.jpg')
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

  describe '#roman_number' do
    it 'accepts numbers between 0 and 3999' do
      error_message = 'Insert value between 1 and 3999'
      expect { helper.roman_number(4000) }.to raise_error(error_message)
      expect { helper.roman_number(-1) }.to raise_error(error_message)
    end

    it 'returns a roman number' do
      expect(helper.roman_number(1)).to eq('I')
      expect(helper.roman_number(6)).to eq('VI')
      expect(helper.roman_number(7)).to eq('VII')
      expect(helper.roman_number(10)).to eq('X')
      expect(helper.roman_number(13)).to eq('XIII')
      expect(helper.roman_number(19)).to eq('XVIV')
      expect(helper.roman_number(20)).to eq('XX')
      expect(helper.roman_number(47)).to eq('XLVII')
      expect(helper.roman_number(50)).to eq('L')
      expect(helper.roman_number(51)).to eq('LI')
      expect(helper.roman_number(95)).to eq('XCV')
      expect(helper.roman_number(100)).to eq('C')
      expect(helper.roman_number(101)).to eq('CI')
      expect(helper.roman_number(200)).to eq('CC')
      expect(helper.roman_number(402)).to eq('CDII')
      expect(helper.roman_number(518)).to eq('DXVIII')
      expect(helper.roman_number(901)).to eq('CMI')
      expect(helper.roman_number(1000)).to eq('M')
      expect(helper.roman_number(2011)).to eq('MMXI')
    end
  end
end
