# frozen_string_literal: true

module RgGen
  module CHeader
    class Feature < Core::OutputBase::Feature
      include Utility

      def macro_definitions
        @macro_definitions ||= []
      end

      private

      def define_macro(name, value = nil)
        macro_definitions <<
          Utility::MacroDefinition.new(name.upcase, value)
      end

      def full_name(separator = '_')
        [register_block.name, component.full_name(separator)].join(separator)
      end
    end
  end
end
