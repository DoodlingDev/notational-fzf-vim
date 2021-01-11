require_relative '../lib/opened_file'
require_relative './spec_helper'
require 'fileutils'

TEST_FILENAME = '123456789'
TEST_FILEPATH = "#{TEST_DIR}/#{TEST_FILENAME}.md"

TEST_FILE_CONTENTS = [
  '# Heading',
  '',
  'Line of Text',
  'Second Line of Text'
]

describe OpenedFile do
  before :each do
    FileUtils.rm_rf(TEST_DIR) if Dir.exist?(TEST_DIR)

    Dir.mkdir(TEST_DIR)

    FileUtils.touch(TEST_FILEPATH)

    TEST_FILE_CONTENTS.each do |line|
      File.write(TEST_FILEPATH, line + "\n", mode: 'a')
    end
  end

  after :each do
    FileUtils.rm_rf(TEST_DIR)
  end

  describe 'self#initialize' do
    it 'should not create a new file on disk' do
      expect do
        OpenedFile.new(TEST_FILEPATH, TEST_DIR)
      end.not_to change {
        files = Dir["#{TEST_DIR}/**/*"] { |file| File.file?(file) }
        files.length
      }
    end

    it 'should read contents from file on disk' do
      file = OpenedFile.new(TEST_FILEPATH, TEST_DIR)

      expect(file.contents).to eq(TEST_FILE_CONTENTS)
    end

    it 'should correctly parse the filename' do
      file = OpenedFile.new(TEST_FILEPATH, TEST_DIR)

      expect(file.filename).to eq(TEST_FILENAME)
    end
  end
end
