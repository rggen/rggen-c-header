# frozen_string_literal: true

RgGen.define_simple_feature(:register, :c_header) do
  c_header do
    build do
      define_macro("#{full_name}_byte_width", byte_width)
      define_macro("#{full_name}_byte_size", byte_size)
      define_array_macros if array?
      define_offset_address_macros
    end

    export def declaration
      type = "uint#{register.width}_t"
      name = register.name
      size = !shared_address? && register.size || nil
      create_declaration(type, name, size)
    end

    private

    def byte_width
      register.byte_width
    end

    def byte_size
      register.byte_size(hierarchical: true)
    end

    def array?
      register.array?(hierarchical: true)
    end

    def shared_address?
      register.settings[:support_shared_address]
    end

    def array_size
      register.array_size(hierarchical: true)
    end

    def define_array_macros
      size_list = array_size
      define_macro("#{full_name}_array_dimension", size_list.size)
      size_list.each_with_index do |size, i|
        define_macro("#{full_name}_array_size_#{i}", size)
      end
    end

    def define_offset_address_macros
      if array?
        address_list.zip(array_suffix) do |address, suffix|
          define_macro("#{full_name}_byte_offset_#{suffix}", hex(address))
        end
      else
        define_macro("#{full_name}_byte_offset", hex(address_list.first))
      end
    end

    def address_list
      register.expanded_offset_addresses
    end

    def array_suffix
      index_list = array_size.map { |size| size.times.to_a }
      index_list.first.product(*index_list[1..]).map { |index| index.join('_') }
    end
  end
end
