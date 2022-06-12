# frozen_string_literal: true

require_relative 'c_header/version'
require_relative 'c_header/utility/macro_definition'
require_relative 'c_header/utility/source_file'
require_relative 'c_header/utility'
require_relative 'c_header/feature'
require_relative 'c_header/component'
require_relative 'c_header/factories'

module RgGen
  module CHeader
    extend Core::Plugin

    setup_plugin :'rggen-c-header' do |plugin|
      plugin.register_component :c_header do
        component Component, ComponentFactory
        feature Feature, FeatureFactory
      end

      plugin.files [
        'c_header/bit_field/c_header',
        'c_header/register/c_header',
        'c_header/register_block/c_header'
      ]
    end
  end
end
