# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      include Core::Utility::CodeUtility

      private

      def hex(value)
        format('0x%x', value)
      end
    end
  end
end
