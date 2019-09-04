module ProgramHelper
  def can_collate_with_db?
    resource.can_collate_with_db? && can?(:check, Program)
  end

  def can_add_port?
    resource.can_add_port? && can?(:new, Port)
  end
end