# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :c_header) do
  c_header do
    include RgGen::CHeader::StructBuilder

    build do
      build_struct
    end

    export def declaration
      create_declaration(
        struct_name, register_file.name, register_file.array_size
      )
    end

    private

    def struct_base_name
      full_name
    end

    def byte_size
      register_file.entry_byte_size
    end
  end
end
