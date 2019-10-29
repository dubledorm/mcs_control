class NginxTemplate < ApplicationRecord
  include ProgramToolBox

  validates :program_type, presence: true, uniqueness: true, inclusion: { in: KNOWN_PROGRAM_TYPES.keys }
end
