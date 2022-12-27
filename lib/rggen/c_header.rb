# frozen_string_literal: true

require_relative 'c_header/version'
require_relative 'c_header/utility/declaration'
require_relative 'c_header/utility/struct_definition'
require_relative 'c_header/utility/source_file'
require_relative 'c_header/utility'
require_relative 'c_header/struct_builder'
require_relative 'c_header/feature'
require_relative 'c_header/component'
require_relative 'c_header/factories'

RgGen.setup_plugin :'rggen-c-header' do |plugin|
  plugin.version RgGen::CHeader::VERSION

  plugin.register_component :c_header do
    component RgGen::CHeader::Component,
              RgGen::CHeader::ComponentFactory
    feature RgGen::CHeader::Feature,
            RgGen::CHeader::FeatureFactory
  end

  plugin.files [
    'c_header/register_block/c_header',
    'c_header/register_file/c_header',
    'c_header/register/c_header',
    'c_header/bit_field/c_header'
  ]
end
