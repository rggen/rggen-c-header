# frozen_string_literal: true

module RgGen
  module CHeader
    module StructBuilder
      private

      def struct_name
        "#{struct_base_name}_t"
      end

      def build_struct
        members = collect_struct_members
        define_struct(struct_name, members)
      end

      def collect_struct_members
        members = []
        offset = 0
        while offset < byte_size
          declaration, size = define_struct_member(offset)
          members << declaration
          offset += size
        end
        members
      end

      def define_struct_member(offset)
        entries = select_children_by_offset(offset)
        if entries.size >= 2
          [define_shared_union(offset, entries), entries.first.total_byte_size]
        elsif entries.size == 1
          [entries.first.declaration, entries.first.total_byte_size]
        else
          [reserved_member(offset), bus_byte_width]
        end
      end

      def select_children_by_offset(offset)
        component.children.select { |child| child.offset_address == offset }
      end

      def define_shared_union(offset, members)
        type = "#{struct_base_name}_reg_#{hex(offset, offset_width)}_t"
        name = "reg_#{hex(offset, offset_width)}"
        define_union(type, members.map(&:declaration))
        create_declaration(type, name)
      end

      def reserved_member(offset)
        type = "uint#{bus_width}_t"
        name = "__reserved_#{hex(offset, offset_width)}"
        create_declaration(type, name)
      end

      def offset_width
        (register_block.byte_size - 1).bit_length
      end

      def bus_width
        register_block.bus_width
      end

      def bus_byte_width
        register_block.byte_width
      end
    end
  end
end
