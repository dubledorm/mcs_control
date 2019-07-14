class InstanceDecorator < ApplicationDecorator
  delegate_all

  def ports
    object.programs.map{|program| program.ports.map{|port| "#{port.number}/#{port.port_type}"}}.flatten.sort
  end

  def database_names
    object.programs.map(&:database_name).compact
  end

  def program_names
    object.programs.map(&:identification_name)
  end
end
