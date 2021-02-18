# frozen_string_literal: true

require_relative '../lib/reference_note'
require_relative '../lib/opened_reference_note'
require_relative '../lib/opened_file'
require_relative './spec_helper'
require 'fileutils'

describe OpenedReferenceNote do
  before :each do
    FileUtils.rm_rf(TEST_DIR) if Dir.exist?(TEST_DIR)
    Dir.mkdir(TEST_DIR)

    ref_file = {
      contents: [
        "<!-- %% #{TEST_DIR} #{TEST_DIR}/file_one.md -->",
        "# Heading 1\n",
        "* bullet 1a\n",
        "* bullet 1b\n",
        '',
        '',
        '',
        "<!-- %% #{TEST_DIR} #{TEST_DIR}/file_three.md -->", # header 1
        '# Heading 3', # lines 1-3
        '* bullet 3a', # lines 1-3
        '* bullet 3b', # lines 1-3
        '',
        '',
        ''
      ],
      filename: 'ref_one.md'
    }
    file_one = {
      contents: [
        "# Heading 1\n",
        "* bullet 1a\n",
        "* bullet 1b\n"
      ],
      filename: 'file_one.md'
    }
    file_two = {
      contents: [
        "# Heading 2\n",
        "* bullet 2a\n",
        "* bullet 2b\n"
      ],
      filename: 'file_two.md'
    }
    file_three = {
      contents: [
        "# Heading 3\n",
        "* bullet 3a\n",
        "* bullet 3b\n"
      ],
      filename: 'file_three.md'
    }
    test_files = [file_one, file_two, file_three, ref_file]

    test_files.each do |f|
      FileUtils.touch("#{TEST_DIR}/#{f[:filename]}")
      f[:contents].each do |line|
        File.write("#{TEST_DIR}/#{f[:filename]}", line, mode: 'a')
      end
    end
  end

  describe "#initialize" do
    it "creates OpenedFile objects for each file in it's contents" do
      subject = OpenedReferenceNote.new("ref_one.md", TEST_DIR)
      expect(subject.refs.length).to eq 2
    end
  end
end

