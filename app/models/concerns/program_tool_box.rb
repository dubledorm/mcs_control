# encoding: UTF-8
module ProgramToolBox
  extend ActiveSupport::Concern

  def can_add_port?
    return false if program_type.blank?
    return true if program_type == 'dcs-dev'
    false
  end

  def can_collate_with_db?
    return false if program_type.blank?
    return true if program_type == 'dcs-dev'
    false
  end
end
