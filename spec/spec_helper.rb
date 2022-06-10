# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'support/matchers'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.plugin_spec.activate(builder)

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/c_header'
#RgGen::VHDL.plugin_spec.activate(builder)

RGGEN_ROOT = ENV['RGGEN_ROOT'] || File.expand_path('../..', __dir__)
RGGEN_C_HEADER_ROOT = File.expand_path('..', __dir__)
RGGEN_SAMPLE_DIRECTORY = File.join(RGGEN_ROOT, 'rggen-sample')
