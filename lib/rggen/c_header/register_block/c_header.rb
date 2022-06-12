# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :c_header) do
  c_header do
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
