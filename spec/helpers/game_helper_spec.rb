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
end