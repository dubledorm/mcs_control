class ProgramDecorator < ApplicationDecorator
  delegate_all

  def ports_str
    object.ports.map(&:number).join(', ')
  end
end
