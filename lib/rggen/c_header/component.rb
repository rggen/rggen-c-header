# frozen_string_literal: true

module RgGen
  module CHeader
    class Component < Core::OutputBase::Component
      def macro_definitions
        [
          @features.each_value.map(&:macro_definitions),
          @children.map(&:macro_definitions)
        ].flatten
      end
    end
  end
end
