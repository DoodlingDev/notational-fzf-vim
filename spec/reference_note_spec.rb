# frozen_string_literal: true

require_relative '../lib/reference_note'
require_relative '../lib/opened_file'
require_relative './spec_helper'
require 'fileutils'

describe ReferenceNote do
  before :each do
    FileUtils.rm_rf(TEST_DIR) if Dir.exist?(TEST_DIR)
    Dir.mkdir(TEST_DIR)

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

    test_files = [file_one, file_two, file_three]

    test_files.each do |f|
      FileUtils.touch("#{TEST_DIR}/#{f[:filename]}")
      f[:contents].each do |line|
        File.write("#{TEST_DIR}/#{f[:filename]}", line, mode: 'a')
      end
    end
  end

  after :each do
    FileUtils.rm_rf(TEST_DIR)
  end

  describe '#generate_aggregate_file' do
    let(:referencing_note_lines) do
      [
        "#{TEST_DIR}/file_one.md:2:# Heading 1",
        "#{TEST_DIR}/file_three.md:2:# Heading 3"
      ]
    end

    it 'creates a reference note with the proper contents' do
      subject = ReferenceNote.new(referencing_note_lines, TEST_DIR)
      subject.generate_aggregate_file

      test_filepath = subject.absolute_path

      ref_file = File.open(test_filepath)
      contents = ref_file.readlines.map(&:chomp)

      expect(contents).to eq([
                               "<!-- %% #{TEST_DIR} #{TEST_DIR}/file_one.md -->", # header 1
                               '# Heading 1', # lines 1-3
                               '* bullet 1a', # lines 1-3
                               '* bullet 1b', # lines 1-3
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
                             ])
    end
  end
end
