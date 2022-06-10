# frozen_string_literal: true

RSpec.describe RgGen::CHeader::Component do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:components) do
    components = []
    components << create_component(nil)
    components << create_component(components.last)
    components << create_component(components.last)
    components
  end

  let(:features) do
    components.flat_map do |component|
      [:foo, :bar].map do |name|
        RgGen::CHeader::Feature.new(name, nil, component) do |f|
          component.add_feature(f)
        end
      end
    end
  end

  def create_component(parent)
    described_class.new(parent, 'component', nil, configuration, register_map) do |c|
      parent && parent.add_child(c)
    end
  end

  describe '#macro_definitions' do
    it '自身及び下位階層で定義されたマクロ定義を返す' do
      features[0].instance_eval { define_macro 'FOO_0_0' }
      features[0].instance_eval { define_macro 'FOO_0_1' }
      features[1].instance_eval { define_macro 'BAR_0_0' }
      features[1].instance_eval { define_macro 'BAR_0_1' }

      expect(components[0].macro_definitions).to match([
        match_macro_definition('#define FOO_0_0'), match_macro_definition('#define FOO_0_1'),
        match_macro_definition('#define BAR_0_0'), match_macro_definition('#define BAR_0_1')
      ])

      features[2].instance_eval { define_macro 'FOO_1_0' }
      features[2].instance_eval { define_macro 'FOO_1_1' }
      features[3].instance_eval { define_macro 'BAR_1_0' }
      features[3].instance_eval { define_macro 'BAR_1_1' }

      expect(components[0].macro_definitions).to match([
        match_macro_definition('#define FOO_0_0'), match_macro_definition('#define FOO_0_1'),
        match_macro_definition('#define BAR_0_0'), match_macro_definition('#define BAR_0_1'),
        match_macro_definition('#define FOO_1_0'), match_macro_definition('#define FOO_1_1'),
        match_macro_definition('#define BAR_1_0'), match_macro_definition('#define BAR_1_1')
      ])

      features[4].instance_eval { define_macro 'FOO_2_0' }
      features[4].instance_eval { define_macro 'FOO_2_1' }
      features[5].instance_eval { define_macro 'BAR_2_0' }
      features[5].instance_eval { define_macro 'BAR_2_1' }

      expect(components[0].macro_definitions).to match([
        match_macro_definition('#define FOO_0_0'), match_macro_definition('#define FOO_0_1'),
        match_macro_definition('#define BAR_0_0'), match_macro_definition('#define BAR_0_1'),
        match_macro_definition('#define FOO_1_0'), match_macro_definition('#define FOO_1_1'),
        match_macro_definition('#define BAR_1_0'), match_macro_definition('#define BAR_1_1'),
        match_macro_definition('#define FOO_2_0'), match_macro_definition('#define FOO_2_1'),
        match_macro_definition('#define BAR_2_0'), match_macro_definition('#define BAR_2_1')
      ])
    end
  end
end
