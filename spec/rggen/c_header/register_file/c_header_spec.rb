# frozen_string_literal: true

RSpec.describe 'register_file/c_header' do
  include_context 'clean-up builder'
  include_context 'c header common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register_file, :c_header)
    RgGen.enable(:register, :c_header)
  end

  let(:c_header) do
    c_header = create_c_header do
      name 'block'
      byte_size 256

      register_file do
        name 'register_file'
        offset_address 0x00

        register do
          name 'register_0'
          offset_address 0x04
          bit_field { name 'bit_field_0_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_1_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          bit_field { name 'bit_field_2_0'; bit_assignment lsb: 0, width: 1; type :ro }
        end

        register do
          name 'register_3'
          offset_address 0x20
          bit_field { name 'bit_field_3_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x24
          size [2]
          bit_field { name 'bit_field_4_0'; bit_assignment lsb: 0, width: 1; type :ro }
        end

        register do
          name 'register_5'
          offset_address 0x24
          size [2, 1]
          bit_field { name 'bit_field_5_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
        end

        register do
          name 'register_6'
          offset_address 0x30
          size [2]
          type [:indirect, ['register_file.register_0.bit_field_0_0', 0], 'register_file.register_3.bit_field_3_0']
          bit_field { name 'bit_field_6_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          offset_address 0x30
          size [2]
          type [:indirect, ['register_file.register_0.bit_field_0_0', 1], 'register_file.register_3.bit_field_3_0']
          bit_field { name 'bit_field_7_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_8'
          offset_address 0x40
          size [2, 2]

          register do
            name 'register_8_0'
            offset_address 0x00
            bit_field { name 'bit_field_8_0_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_8_1'
            offset_address 0x0c
            bit_field { name 'bit_field_8_1_0'; bit_assignment lsb: 0, width: 1; type :ro }
          end

          register do
            name 'register_8_2'
            offset_address 0x0c
            bit_field { name 'bit_field_8_2_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
          end
        end

        register do
          name 'register_9_0'
          offset_address 0x90
          bit_field { name 'bit_field_9_0_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end
      end
    end
    c_header.register_files
  end

  describe '#declaration' do
    it '宣言を行うコードを返す' do
      expect(c_header[0].declaration).to match_string('block_register_file_t register_file')
      expect(c_header[1].declaration).to match_string('block_register_file_register_file_8_t register_file_8[2][2]')
    end
  end

  describe '構造体/共用体定義' do
    it 'アドレスマップを示す構造体/共用体を定義する' do
      expect(c_header[0].struct_definitions[0]).to match_string(<<~'CODE')
        typedef union {
          uint32_t register_8_1;
          uint32_t register_8_2;
        } block_register_file_register_file_8_reg_0x0c_t;
      CODE

      expect(c_header[0].struct_definitions[1]).to match_string(<<~'CODE')
        typedef struct {
          uint32_t register_8_0;
          uint32_t __reserved_0x04;
          uint32_t __reserved_0x08;
          block_register_file_register_file_8_reg_0x0c_t reg_0x0c;
        } block_register_file_register_file_8_t;
      CODE

      expect(c_header[0].struct_definitions[2]).to match_string(<<~'CODE')
        typedef union {
          uint32_t register_2;
          uint32_t register_3;
        } block_register_file_reg_0x20_t;
      CODE

      expect(c_header[0].struct_definitions[3]).to match_string(<<~'CODE')
        typedef union {
          uint32_t register_4[2];
          uint32_t register_5[2][1];
        } block_register_file_reg_0x24_t;
      CODE

      expect(c_header[0].struct_definitions[4]).to match_string(<<~'CODE')
        typedef union {
          uint32_t register_6;
          uint32_t register_7;
        } block_register_file_reg_0x30_t;
      CODE

      expect(c_header[0].struct_definitions[5]).to match_string(<<~'CODE')
        typedef struct {
          uint32_t __reserved_0x00;
          uint32_t register_0;
          uint32_t register_1[2];
          uint32_t __reserved_0x10;
          uint32_t __reserved_0x14;
          uint32_t __reserved_0x18;
          uint32_t __reserved_0x1c;
          block_register_file_reg_0x20_t reg_0x20;
          block_register_file_reg_0x24_t reg_0x24;
          uint32_t __reserved_0x2c;
          block_register_file_reg_0x30_t reg_0x30;
          uint32_t __reserved_0x34;
          uint32_t __reserved_0x38;
          uint32_t __reserved_0x3c;
          block_register_file_register_file_8_t register_file_8[2][2];
          uint32_t __reserved_0x80;
          uint32_t __reserved_0x84;
          uint32_t __reserved_0x88;
          uint32_t __reserved_0x8c;
          uint32_t register_9_0;
        } block_register_file_t;
      CODE
    end
  end
end
