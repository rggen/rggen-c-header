# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :c_header) do
  c_header do
    pre_build do
      if configuration.enable_wide_register?
        message =
          'enabling wide register is not allowed ' \
          'for c header file generation'
        raise RgGen::Core::Configuration::ConfigurationError.new(message)
      end
    end

    write_file '<%= register_block.name %>.h' do |f|
      f.include_guard
      f.body do |code|
        register_block.macro_definitions.each do |macro|
          code << macro << nl
        end
      end
    end
  end
end
