require 'rails_helper'
require_relative '../support/shared_examples/sluggable'

describe User, type: :model do
  it { should have_many :characters }
  it { should have_many :subscriptions }
  it { should validate_length_of :name }
  it { should validate_presence_of :name }
  it { should validate_presence_of :password }

  it_behaves_like 'a sluggable', 'john-doe' do
    let(:sluggable) { create(:user) }
  end

  describe '#valid_password?' do
    context 'not a legacy user' do
      let(:user) { create(:user) }

      it 'detects a valid password' do
        expect(user.valid_password?('12345678')).to be true
      end

      it 'detects an invalid password' do
        expect(user.valid_password?('bogus')).to be false
      end
    end

    context 'legacy user' do
      let(:user) { create(:user, legacy_password: Devise::Encryptable::Encryptors::Md5.digest('123', nil, nil, nil)) }

      it 'converts an old account to the new devise authentication' do
        password = '123'
        expect(user.valid_password?(password)).to be true
        expect(user.legacy_password).to be_nil
      end

      it 'detects an invalid password' do
        password = 'abc'
        expect(user.valid_password?(password)).to be false
        expect(user.legacy_password).not_to be_nil
      end
    end
  end
end
