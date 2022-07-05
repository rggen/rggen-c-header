# frozen_string_literal: true

RSpec.describe RgGen::CHeader::Utility::StructDefinition do
  def define_struct(name, members)
    described_class.new(:struct, name, members).to_code
  end

  def define_union(name, members)
    described_class.new(:union, name, members).to_code
  end

  def declaration(type, name, array_size = nil)
    RgGen::CHeader::Utility::Declaration.new(type, name, array_size)
  end

  describe '#to_code' do
    it '構造体/共用体定義を行うコードを返す' do
      struct = define_struct(:foo_struct, [
        declaration(:uint32_t, :foo)
      ])
      expect(struct).to match_string(<<~'CODE')
        typedef struct {
          uint32_t foo;
        } foo_struct;
      CODE

      struct = define_struct(:foo_struct, [
        declaration(:uint32_t, :foo),
        declaration(:uint32_t, :bar, [2])
      ])
      expect(struct).to match_string(<<~'CODE')
        typedef struct {
          uint32_t foo;
          uint32_t bar[2];
        } foo_struct;
      CODE

      struct = define_struct(:foo_struct, [
        declaration(:uint32_t, :foo, [2, 4]),
        declaration(:uint32_t, :bar)
      ])
      expect(struct).to match_string(<<~'CODE')
        typedef struct {
          uint32_t foo[2][4];
          uint32_t bar;
        } foo_struct;
      CODE

      union = define_union(:foo_union, [
        declaration(:uint32_t, :foo)
      ])
      expect(union).to match_string(<<~'CODE')
        typedef union {
          uint32_t foo;
        } foo_union;
      CODE

      union = define_union(:foo_union, [
        declaration(:uint32_t, :foo),
        declaration(:uint32_t, :bar, [2])
      ])
      expect(union).to match_string(<<~'CODE')
        typedef union {
          uint32_t foo;
          uint32_t bar[2];
        } foo_union;
      CODE

      union = define_union(:foo_union, [
        declaration(:uint32_t, :foo, [2, 4]),
        declaration(:uint32_t, :bar)
      ])
      expect(union).to match_string(<<~'CODE')
        typedef union {
          uint32_t foo[2][4];
          uint32_t bar;
        } foo_union;
      CODE
    end
  end
end
