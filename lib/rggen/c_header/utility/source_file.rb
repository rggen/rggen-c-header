# frozen_string_literal: true

module RgGen
  module CHeader
    class SourceFile < Core::Utility::CodeUtility::SourceFile
      ifndef_keyword '#ifndef'
      endif_keyword '#endif'
      define_keyword '#define'
      include_keyword '#include'
    end
  end
end
