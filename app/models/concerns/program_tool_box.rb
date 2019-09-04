# encoding: UTF-8
require 'program_type_characteristic'

module ProgramToolBox
  extend ActiveSupport::Concern

  class DcsDevProgramType < ProgramTypeCharacteristic
    def can_add_port?
      true
    end

    def can_collate_with_db?
      true
    end
  end

  class DcsCliProgramType < ProgramTypeCharacteristic; end

  class OpProgramType < ProgramTypeCharacteristic; end

  class McProgramType < ProgramTypeCharacteristic; end


  KNOWN_PROGRAM_TYPES = { 'dcs-dev' => DcsDevProgramType.new,
                          'dcs-cli' => DcsCliProgramType.new,
                          'op' => OpProgramType.new,
                          'mc' => McProgramType.new }.freeze


  def can_add_port?
    KNOWN_PROGRAM_TYPES[program_type].can_add_port?
  end

  def can_collate_with_db?
    KNOWN_PROGRAM_TYPES[program_type].can_collate_with_db?
  end
end
