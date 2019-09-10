module InstanceHelper
  def can_collate_with_db?
    can?(:check, Instance)
  end

  def can_add_program?
    can?(:new, Program)
  end
end