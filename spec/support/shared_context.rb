# frozen_string_literal: true

RSpec.shared_context 'c header common' do
  include_context 'configuration common'
  include_context 'register map common'

  def build_c_header_factory(builder)
    builder.build_factory(:output, :c_header)
  end

  def create_c_header(configuration = nil, &data_block)
    register_map =
      create_register_map(configuration) { register_block(&data_block) }
    @c_header_factory[0] ||= build_c_header_factory(RgGen.builder)
    @c_header_factory[0].create(configuration || default_configuration, register_map)
  end

  def delete_c_header_factory
    @c_header_factory.clear
  end

  before(:all) do
    @c_header_factory ||= []
  end
end
