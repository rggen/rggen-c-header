# frozen_string_literal: true

require 'rggen/c_header'

RgGen.register_plugin RgGen::CHeader do |builder|
  builder.enable :register_block, [:c_header]
  builder.enable :register, [:c_header]
  builder.enable :bit_field, [:c_header]
end
