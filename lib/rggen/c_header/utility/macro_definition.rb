# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      class MacroDefinition
        def initialize(name, value = nil)
          @name = name
          @value = value
        end

        def to_s
          @value && "#define #{@name} #{@value}" || "#define #{@name}"
        end
      end
    end
  end
end
