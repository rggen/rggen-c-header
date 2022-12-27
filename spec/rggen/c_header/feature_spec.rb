# frozen_string_literal: true

RSpec.describe RgGen::CHeader::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:component) do
    RgGen::CHeader::Component.new(nil, 'component', nil, configuration, register_map)
  end

  let(:feature) do
    Class.new(described_class).new(:foo, nil, component) do |f|
      component.add_feature(f)
    end
  end

  describe '#define_macro' do
    it 'マクロを定義する' do
      feature.instance_eval { define_macro 'FOO' }
      feature.instance_eval { define_macro 'BAR', 0 }
      feature.instance_eval { define_macro 'BAZ', hex(0xdead_beaf) }

      expect(feature.macro_definitions).to match([
        match_macro_definition('FOO'),
        match_macro_definition('BAR', 0),
        match_macro_definition('BAZ', '0xdeadbeaf')
      ])
    end
  end
end
