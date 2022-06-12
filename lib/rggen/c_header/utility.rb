# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      include Core::Utility::CodeUtility

      def create_blank_file(path)
        SourceFile.new(path)
      end

      private

      def hex(value)
        format('0x%x', value)
      end
    end
  end
end
