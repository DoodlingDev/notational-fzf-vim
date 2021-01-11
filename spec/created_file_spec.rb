require_relative '../lib/creatd_file.rb'
require_relative './spec_helper.rb'
require 'fileutils'

describe CreatedFile do
  before :each do
    if Dir.exists?(TEST_DIR)
      FileUtils.rm_rf(TEST_DIR)
    end
    Dir.mkdir(TEST_DIR)
  end

  after :each do
    FileUtils.rm_rf(TEST_DIR)
  end

  describe "self#initialize" do
    it "should create a new file on disk" do
      expect {
        CreatedFile.new('test title',TEST_DIR)
      }.to change {
        files = Dir["#{TEST_DIR}/**/*"] { |file| File.file?(file) }
        files.length
      }.by 1
    end

    it "should create two files even if in the same second" do
      expect {
        CreatedFile.new('test title',TEST_DIR)
        CreatedFile.new('test title',TEST_DIR)
      }.to change {
        files = Dir["#{TEST_DIR}/**/*"] { |file| File.file?(file) }
        files.length
      }.by 2
    end

    it "should create the file with the given title" do
      CreatedFile.new('test title 123', TEST_DIR)
      text_files = Dir.new(TEST_DIR).entries.filter do |filename|
        filename.match /\.md/
      end

      created_filename = text_files[0]
      test_file = File.new("#{TEST_DIR}/#{created_filename}")
      file_title = test_file.readlines[0]

      expect(file_title).to eq "# test title 123\n"
    end
  end
end
