# frozen_string_literal: true

RgGen.define_simple_feature(:register, :c_header) do
  c_header do
    pre_build do
      if register.width > 64
        message =
          'register of which width is wider than 64 bits is not allowed: ' \
          "#{full_name('.')} width #{register.width}"
        raise RgGen::Core::RegisterMap::RegisterMapError.new(message)
      end
    end

    build do
      define_macro("#{full_name}_byte_width", byte_width)
      define_macro("#{full_name}_byte_size", byte_size)
      define_array_macros if array?
      define_offset_address_macros
    end

    private

    def byte_width
      register.byte_width
    end

    def byte_size
      array_size_upper_layer.inject(1, :*) * register.byte_size
    end

    def array?
      register_files.any?(&:array?) || register.array?
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
      upper_address_list = register_file&.expanded_offset_addresses || [0]
      upper_address_list.product(local_address_list).map(&:sum)
    end

    def local_address_list
      Array.new(register.count) do |i|
        if register.settings[:support_shared_address]
          register.offset_address
        else
          register.offset_address + register.byte_width * i
        end
      end
    end

    def array_suffix
      index_list = array_size.map { |size| size.times.to_a }
      index_list.first.product(*index_list[1..]).map { |index| index.join('_') }
    end

    def array_size_upper_layer
      register_files.flat_map(&:array_size).compact
    end

    def array_size
      [*register_files, register].flat_map(&:array_size).compact
    end
  end
end
