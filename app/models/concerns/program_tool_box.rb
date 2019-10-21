# encoding: UTF-8
require 'program_type_characteristic'
require 'program_types'

module ProgramToolBox
  extend ActiveSupport::Concern


  KNOWN_PROGRAM_TYPES = { 'dcs-dev' => ProgramTypes::DcsDevProgramType.new,
                          'dcs-cli' => ProgramTypes::DcsCliProgramType.new,
                          'op' => ProgramTypes::OpProgramType.new,
                          'mc' => ProgramTypes::McProgramType.new,
                          'pf2' => ProgramTypes::Pf2ProgramType.new,
                          'pp-router' => ProgramTypes::PpRouterType.new,
                          'pp-web' => ProgramTypes::PpWebType.new,
                          'pp-admin' => ProgramTypes::PpAdminType.new}.freeze


  def can_add_port?
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].can_add_port?
  end

  def can_delete_port?
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].can_delete_port?
  end

  def can_retranslate_port?
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].can_retranslate_port?
  end

  def can_collate_with_db?
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].can_collate_with_db?
  end

  def port_type
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].port_type
  end

  def default_ports_create
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].default_ports_create
  end

  def after_create
    return false if program_type.nil?
    KNOWN_PROGRAM_TYPES[program_type].after_create(self)
  end
end
