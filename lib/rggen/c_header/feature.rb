# frozen_string_literal: true

module RgGen
  module CHeader
    class Feature < Core::OutputBase::Feature
      include Utility

      def macro_definitions
        @macro_definitions ||= []
      end

      def struct_definitions
        @struct_definitions ||= []
      end

      private

      def define_macro(name, value = nil)
        macro_definitions <<
          Utility::MacroDefinition.new(name.upcase, value)
      end

      def define_struct(name, members)
        struct_definitions <<
          Utility::StructDefinition.new(:struct, name, members)
      end

      def define_union(name, members)
        struct_definitions <<
          Utility::StructDefinition.new(:union, name, members)
      end

      def full_name(separator = '_')
        [register_block.name, component.full_name(separator)].join(separator)
      end
    end
  end
end
