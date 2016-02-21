# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'a sluggable' do |expected_slug|
  it { should validate_presence_of :slug }

  it 'creates its own slug' do
    expect(sluggable.slug).to eq(expected_slug)
  end
end
