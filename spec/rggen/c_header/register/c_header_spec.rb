# frozen_string_literal: true

RSpec.describe 'register/c_header' do
  include_context 'clean-up builder'
  include_context 'c header common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register, :c_header)
  end

  let(:c_header) do
    c_header = create_c_header do
      name 'block_0'
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { name 'bit_field_0'; bit_assignment lsb: 32, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_3'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_4'
        offset_address 0x10
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x20
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x30
        size [2, step: 8]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x40
        size [4]
        type [:indirect, 'register_0.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_8'
        offset_address 0x44
        size [2, 2]
        type [:indirect, 'register_0.bit_field_0', 'register_1.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_9'
        offset_address 0x50
        size [4]
        type :external
      end

      register_file do
        name 'register_file_10'
        offset_address 0x60

        register do
          name 'register_10_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_10_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_10_2'
          offset_address 0x10

          register do
            name 'register_10_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_10_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_11'
        offset_address 0x80
        size [2, 2]

        register do
          name 'register_11_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_11_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_11_2'
          offset_address 0x10

          register do
            name 'register_11_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_11_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end
    end
    c_header.registers
  end

  describe 'マクロ定義' do
    it 'バイト幅/バイト長/配列次元/配列長/オフセットアドレスを示すマクロを定義する' do
      expect(c_header[0].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_0_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_0_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_0_BYTE_OFFSET', '0x0')
      ])

      expect(c_header[1].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_1_BYTE_WIDTH', 8),
        match_macro_definition('BLOCK_0_REGISTER_1_BYTE_SIZE', 8),
        match_macro_definition('BLOCK_0_REGISTER_1_BYTE_OFFSET', '0x4')
      ])

      expect(c_header[2].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_2_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_2_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_2_BYTE_OFFSET', '0xc')
      ])

      expect(c_header[3].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_3_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_3_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_3_BYTE_OFFSET', '0xc')
      ])

      expect(c_header[4].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_4_ARRAY_DIMENSION', 1),
        match_macro_definition('BLOCK_0_REGISTER_4_ARRAY_SIZE_0', 4),
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_OFFSET_0', '0x10'),
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_OFFSET_1', '0x14'),
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_OFFSET_2', '0x18'),
        match_macro_definition('BLOCK_0_REGISTER_4_BYTE_OFFSET_3', '0x1c')
      ])

      expect(c_header[5].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_5_ARRAY_DIMENSION', 2),
        match_macro_definition('BLOCK_0_REGISTER_5_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_5_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_OFFSET_0_0', '0x20'),
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_OFFSET_0_1', '0x24'),
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_OFFSET_1_0', '0x28'),
        match_macro_definition('BLOCK_0_REGISTER_5_BYTE_OFFSET_1_1', '0x2c')
      ])

      expect(c_header[6].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_6_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_6_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_6_ARRAY_DIMENSION', 1),
        match_macro_definition('BLOCK_0_REGISTER_6_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_6_BYTE_OFFSET_0', '0x30'),
        match_macro_definition('BLOCK_0_REGISTER_6_BYTE_OFFSET_1', '0x38')
      ])

      expect(c_header[7].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_7_ARRAY_DIMENSION', 1),
        match_macro_definition('BLOCK_0_REGISTER_7_ARRAY_SIZE_0', 4),
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_OFFSET_0', '0x40'),
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_OFFSET_1', '0x40'),
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_OFFSET_2', '0x40'),
        match_macro_definition('BLOCK_0_REGISTER_7_BYTE_OFFSET_3', '0x40')
      ])

      expect(c_header[8].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_8_ARRAY_DIMENSION', 2),
        match_macro_definition('BLOCK_0_REGISTER_8_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_8_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_OFFSET_0_0', '0x44'),
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_OFFSET_0_1', '0x44'),
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_OFFSET_1_0', '0x44'),
        match_macro_definition('BLOCK_0_REGISTER_8_BYTE_OFFSET_1_1', '0x44')
      ])

      expect(c_header[9].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_9_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_9_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_9_BYTE_OFFSET', '0x50')
      ])

      expect(c_header[10].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET', '0x60')
      ])

      expect(c_header[11].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_SIZE', 8),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_DIMENSION', 1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_0', '0x68'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET_1', '0x6c')
      ])

      expect(c_header[12].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_SIZE', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET', '0x70')
      ])

      expect(c_header[13].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_SIZE', 8),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_DIMENSION', 1),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_0', '0x78'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET_1', '0x7c')
      ])

      expect(c_header[14].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_ARRAY_DIMENSION', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_OFFSET_0_0', '0x80'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_OFFSET_0_1', '0xa0'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_OFFSET_1_0', '0xc0'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_0_BYTE_OFFSET_1_1', '0xe0')
      ])

      expect(c_header[15].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_SIZE', 32),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_ARRAY_DIMENSION', 3),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_ARRAY_SIZE_2', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_0_0_0', '0x88'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_0_0_1', '0x8c'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_0_1_0', '0xa8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_0_1_1', '0xac'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_1_0_0', '0xc8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_1_0_1', '0xcc'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_1_1_0', '0xe8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_11_1_BYTE_OFFSET_1_1_1', '0xec')
      ])

      expect(c_header[16].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_SIZE', 16),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_ARRAY_DIMENSION', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_OFFSET_0_0', '0x90'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_OFFSET_0_1', '0xb0'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_OFFSET_1_0', '0xd0'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_0_BYTE_OFFSET_1_1', '0xf0')
      ])

      expect(c_header[17].macro_definitions).to match([
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_WIDTH', 4),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_SIZE', 32),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_ARRAY_DIMENSION', 3),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_ARRAY_SIZE_0', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_ARRAY_SIZE_1', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_ARRAY_SIZE_2', 2),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_0_0_0', '0x98'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_0_0_1', '0x9c'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_0_1_0', '0xb8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_0_1_1', '0xbc'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_1_0_0', '0xd8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_1_0_1', '0xdc'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_1_1_0', '0xf8'),
        match_macro_definition('BLOCK_0_REGISTER_FILE_11_REGISTER_FILE_11_2_REGISTER_11_2_1_BYTE_OFFSET_1_1_1', '0xfc')
      ])
    end
  end

  describe '#declaration' do
    it '変数宣言を行うコードを返す' do
      expect(c_header[0].declaration).to match_string('uint32_t register_0')
      expect(c_header[1].declaration).to match_string('uint64_t register_1')
      expect(c_header[4].declaration).to match_string('uint32_t register_4[4]')
      expect(c_header[5].declaration).to match_string('uint32_t register_5[2][2]')
      expect(c_header[6].declaration).to match_string('uint64_t register_6[2]')
      expect(c_header[7].declaration).to match_string('uint32_t register_7')
      expect(c_header[8].declaration).to match_string('uint32_t register_8')
      expect(c_header[9].declaration).to match_string('uint32_t register_9[4]')
      expect(c_header[10].declaration).to match_string('uint32_t register_10_0')
      expect(c_header[11].declaration).to match_string('uint32_t register_10_1[2]')
      expect(c_header[12].declaration).to match_string('uint32_t register_10_2_0')
      expect(c_header[13].declaration).to match_string('uint32_t register_10_2_1[2]')
      expect(c_header[14].declaration).to match_string('uint32_t register_11_0')
      expect(c_header[15].declaration).to match_string('uint32_t register_11_1[2]')
      expect(c_header[16].declaration).to match_string('uint32_t register_11_2_0')
      expect(c_header[17].declaration).to match_string('uint32_t register_11_2_1[2]')
    end
  end
end
