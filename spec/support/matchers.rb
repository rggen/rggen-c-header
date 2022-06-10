# frozen_string_literal: true

RSpec::Matchers.define :match_macro_definition do |expected_definition|
  match do |actual|
    @actual_definition = actual.to_s
    values_match?(expected_definition, @actual_definition)
  end

  failure_message do
    "expected: #{expected_definition}\n" \
    "     got: #{@actual_definition}\n\n"
  end
end
