# frozen_string_literal: true

RSpec.describe RgGen::CHeader do
  it 'has a version number' do
    expect(RgGen::CHeader::VERSION).not_to be nil
  end
end
