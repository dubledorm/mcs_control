module InstanceHelper
  def can_collate_with_db?
    can?(:check, Instance)
  end
end