# frozen_string_literal: true

require_relative './reference_note'
require_relative './utils'

# reference note that reads from
# an already existing generated reference note
class OpenedReferenceNote < ReferenceNote
  attr_reader :dir_path

  def initialize; end
end
