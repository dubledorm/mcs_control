class PortDecorator < ObjectBaseDecorator
  delegate_all

  def program_name
    return '' if object.program.blank?
    object.program.identification_name
  end

  def instance_name
    return '' if object.instance.blank?
    object.instance.name
  end

  def port_names
    return [number.to_s]
  end

  def database_names
    return []
  end

  def program_names
    return []
  end
end