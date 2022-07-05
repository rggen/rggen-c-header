# frozen_string_literal: true

module RgGen
  module CHeader
    class Component < Core::OutputBase::Component
      def macro_definitions
        [
          @children.map(&:macro_definitions),
          @features.each_value.map(&:macro_definitions)
        ].flatten
      end

      def struct_definitions
        [
          @children.map(&:struct_definitions),
          @features.each_value.map(&:struct_definitions)
        ].flatten
      end
    end
  end
end
