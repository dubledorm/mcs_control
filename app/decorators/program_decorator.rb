class ProgramDecorator < ObjectBaseDecorator
  delegate_all

  def ports_str
    object.ports.map(&:number).join(', ')
  end

  def port_names
    object.ports.map{|port| "#{port.number}/#{port.port_type}"}.sort
  end

  def database_names
    return [] if object.database_name.blank?
    [object.database_name]
  end

  def program_names
    return [] if object.identification_name.blank?
    [object.identification_name]
  end

  def http_prefix
    object.http_prefix
   end
end
