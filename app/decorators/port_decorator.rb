class PortDecorator < ApplicationDecorator
  def program_name
    return '' if object.program.blank?
    object.program.identification_name
  end
end