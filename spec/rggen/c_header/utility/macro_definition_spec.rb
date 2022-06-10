# frozen_string_literal: true

RSpec.describe RgGen::CHeader::Utility::MacroDefinition do
  def macro_definition(name, value = nil)
    described_class.new(*[name, value].compact)
  end

  describe '#to_s' do
    it 'マクロ定義を行うコードを返す' do
      expect(macro_definition('FOO')).to match_macro_definition('#define FOO')
      expect(macro_definition('BAR', 1)).to match_macro_definition('#define BAR 1')
      expect(macro_definition('BAZ', '0xdeadbeaf')).to match_macro_definition('#define BAZ 0xdeadbeaf')
    end
  end
end
