# frozen_string_literal: true

RSpec.describe 'register_block/c_header' do
  include_context 'clean-up builder'
  include_context 'c header common'

  before(:all) do
    RgGen.define_simple_feature(:register_block, :protocol) do
      configuration { build {} }
    end
    RgGen.enable_all
  end

  after(:all) do
    RgGen.delete(:register_block, :protocol)
  end

  context '幅広レジスタが許可されている場合' do
    it 'SourceErrorを起こす' do
      configuration =
        create_configuration(enable_wide_register: true)
      expect {
        create_c_header(configuration) do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4; type :rw; initial_value 0 }
          end
        end
      }.to raise_source_error 'enabling wide register is not allowed for c header file generation'
    end
  end

  describe '#write_file' do
    before do
      allow(FileUtils).to receive(:mkpath)
    end

    let(:configuration) do
      file = ['config.json', 'config.toml', 'config.yml'].sample
      path = File.join(RGGEN_SAMPLE_DIRECTORY, file)
      build_configuration_factory(RgGen.builder, false).create([path])
    end

    let(:register_map) do
      file_0 = ['block_0.rb', 'block_0.toml', 'block_0.yml'].sample
      file_1 = ['block_1.rb', 'block_1.toml', 'block_1.yml'].sample
      path = [file_0, file_1].map { |file| File.join(RGGEN_SAMPLE_DIRECTORY, file) }
      build_register_map_factory(RgGen.builder, false).create(configuration, path)
    end

    let(:c_header) do
      build_c_header_factory(RgGen.builder).create(configuration, register_map).register_blocks
    end

    let(:expected_code) do
      [
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_0.h'),
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_1.h')
      ].map { |path| File.binread(path) }
    end

    it 'Cヘッダーファイルを出力する' do
      expect {
        c_header[0].write_file('foo')
      }.to write_file(match_string('foo/block_0.h'), expected_code[0])

      expect {
        c_header[1].write_file('bar')
      }.to write_file(match_string('bar/block_1.h'), expected_code[1])
    end
  end
end
