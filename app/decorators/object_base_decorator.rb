class ObjectBaseDecorator < ApplicationDecorator
  def port_names
    raise NotImplementedError
  end

  def database_names
    raise NotImplementedError
  end

  def program_names
    raise NotImplementedError
  end
end