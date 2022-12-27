# frozen_string_literal: true

RSpec.describe 'bit_field/c_header' do
  include_context 'clean-up builder'
  include_context 'c header common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:bit_field, :c_header)
  end

  describe 'マクロ定義' do
    let(:c_header) do
      c_header = create_c_header do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width:  4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 24, width: 16; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          bit_field { bit_assignment lsb: 0, width: 64; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_4'
          register do
            name 'register_4_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          end
          register do
            name 'register_4_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          end
          register_file do
            name 'register_file_4_2'
            size [2, 2]
            register do
              name 'register_4_2_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
            end
            register do
              name 'register_4_2_1'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
            end
          end
        end
      end
      c_header.bit_fields
    end

    it 'ビット幅/ビットマスク/ビット位置を示すマクロが定義される' do
      expect(c_header[0].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_0_BIT_WIDTH', 1),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_0_BIT_MASK',  '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_0_BIT_OFFSET', 0)
      ])

      expect(c_header[1].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_1_BIT_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_1_BIT_MASK', '0xf'),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_1_BIT_OFFSET', 16)
      ])

      expect(c_header[2].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_2_BIT_WIDTH', 16),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_2_BIT_MASK', '0xffff'),
        match_macro_definition('BLOCK_0_REGISTER_0_BIT_FIELD_2_BIT_OFFSET', 24)
      ])

      expect(c_header[3].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_1_BIT_WIDTH', 64),
        match_macro_definition('BLOCK_0_REGISTER_1_BIT_MASK', '0xffffffffffffffff'),
        match_macro_definition('BLOCK_0_REGISTER_1_BIT_OFFSET', 0)
      ])

      expect(c_header[4].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_MASK', '0xf'),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_OFFSET_0', 0),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_OFFSET_1', 8),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_OFFSET_2', 16),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_0_BIT_OFFSET_3', 24)
      ])

      expect(c_header[5].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_MASK', '0xf'),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_OFFSET_0', 4),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_OFFSET_1', 12),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_OFFSET_2', 20),
        match_macro_definition('BLOCK_0_REGISTER_2_BIT_FIELD_1_BIT_OFFSET_3', 28)
      ])

      expect(c_header[6].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_3_BIT_FIELD_0_BIT_WIDTH', 1),
        match_macro_definition('BLOCK_0_REGISTER_3_BIT_FIELD_0_BIT_MASK', '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_3_BIT_FIELD_0_BIT_OFFSET', 0)
      ])

      expect(c_header[7].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_WIDTH', 1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_MASK', '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_OFFSET', 0)
      ])

      expect(c_header[8].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_WIDTH ',1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_MASK', '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_OFFSET', 0)
      ])

      expect(c_header[9].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_WIDTH', 1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_MASK', '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_OFFSET', 0)
      ])

      expect(c_header[10].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_WIDTH', 1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_MASK', '0x1'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_OFFSET', 0)
      ])
    end
  end
end
