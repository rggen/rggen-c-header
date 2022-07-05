# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      include Core::Utility::CodeUtility

      def create_blank_file(path)
        SourceFile.new(path)
      end

      private

      def hex(value, width = nil)
        if width
          print_width = ([1, value.bit_length, width].max + 3) / 4
          format('0x%0*x', print_width, value)
        else
          format('0x%x', value)
        end
      end

      def create_declaration(type, name, array_size = nil)
        Declaration.new(type, name, array_size)
      end
    end
  end
end
