require_relative '../lib/note_file'
require_relative './spec_helper'
require 'fileutils'

describe NoteFile do
  before :each do
    FileUtils.rm_rf(TEST_DIR) if Dir.exist?(TEST_DIR)
    Dir.mkdir(TEST_DIR)
  end

  after :each do
    FileUtils.rm_rf(TEST_DIR)
  end

  describe 'self#initialize' do
    it 'should set the dir path instance variable' do
      # notefile must be instantiated through a subclass
      f = CreatedFile.new('query string', TEST_DIR)
      expect(f.dir_path).to eq TEST_DIR
    end

    it 'should error if no filename or contents were set by a subclass' do
      expect do
        NoteFile.new(TEST_DIR)
      end.to raise_error(StandardError,
                         'NoteFile should be instantiated by a subclass which sets filename and contents')
    end
  end
  # describe "self#create" do
  #   it "should create a new file on disk" do
  #     expect {
  #       NoteFile.create('test title',TEST_DIR)
  #     }.to change {
  #       files = Dir["#{TEST_DIR}/**/*"] { |file| File.file?(file) }
  #       files.length
  #     }.by 1
  #   end

  #   it "should create two files even if in the same second" do
  #     expect {
  #       NoteFile.create('test title',TEST_DIR)
  #       NoteFile.create('test title',TEST_DIR)
  #     }.to change {
  #       files = Dir["#{TEST_DIR}/**/*"] { |file| File.file?(file) }
  #       files.length
  #     }.by 2
  #   end

  #   it "should create the file with the given title" do
  #     NoteFile.create('test title 123', TEST_DIR)
  #     text_files = Dir.new(TEST_DIR).entries.filter do |filename|
  #       filename.match /\.md/
  #     end

  #     created_filename = text_files[0]
  #     test_file = File.new("#{TEST_DIR}/#{created_filename}")
  #     file_title = test_file.readlines[0]

  #     expect(file_title).to eq "# test title 123\n"
  #   end
  # end
end
