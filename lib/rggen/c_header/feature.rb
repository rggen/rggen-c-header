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

      def full_name
        "#{register_block.name}_#{component.full_name('_')}"
      end
    end
  end
end
