module InstanceHelper
  def instance_can_collate_with_db?
    can?(:check, Instance)
  end

  def instance_can_add_program?
    can?(:new, Program)
  end

  def instance_can_add_pf2?
    can?(:new, Program) && Program.pf2_only.count == 0
  end
end