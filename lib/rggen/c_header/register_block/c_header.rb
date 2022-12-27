# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :c_header) do
  c_header do
    include RgGen::CHeader::StructBuilder

    pre_build do
      if configuration.enable_wide_register?
        message =
          'enabling wide register is not allowed ' \
          'for c header file generation'
        raise RgGen::Core::Configuration::ConfigurationError.new(message)
      end
    end

    build do
      build_struct
    end

    write_file '<%= register_block.name %>.h' do |f|
      f.include_guard
      f.include_file 'stdint.h'
      f.macro_definitions register_block.macro_definitions
      f.body do |code|
        register_block.struct_definitions.each do |struct|
          code << struct
        end
      end
    end

    private

    def struct_base_name
      register_block.name
    end

    def byte_size
      register_block.byte_size
    end
  end
end
