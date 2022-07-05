# frozen_string_literal: true

module RgGen
  module CHeader
    module Utility
      class StructDefinition < Core::Utility::CodeUtility::StructureDefinition
        def initialize(type, name, members)
          @type = type
          @name = name
          @members = members
          super()
        end

        private

        def code_blocks
          blocks = []
          blocks << [method(:header_code), 0]
          blocks << [method(:body_code), 2]
          blocks << [method(:footer_code), 0]
          blocks
        end

        def header_code(code)
          code << 'typedef' << space << @type << space << '{' << nl
        end

        def body_code(code)
          @members.each do |member|
            code << member << semicolon << nl
          end
        end

        def footer_code(code)
          code << '}' << space << @name << semicolon << nl
        end
      end
    end
  end
end
