# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      Declaration = Struct.new(:type, :name, :array_size) do
        def to_s
          [
            type, ' ', name, array_size&.map { |size| "[#{size}]" }
          ].compact.join
        end
      end
    end
  end
end
