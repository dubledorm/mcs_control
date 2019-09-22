module ProgramHelper
  def program_can_collate_with_db?
    resource.can_collate_with_db? && can?(:check, Program)
  end

  def program_can_add_port?
    resource.can_add_port? && can?(:new, Port)
  end

  def program_can_delete_port?
    resource.can_delete_port? && can?(:delete, Port)
  end


  # Определяет программы каких типов ещё можно добавить к инстансу
  # При этом, считаем, что mc можем добавить любое количество
  def program_available_program_types
    (ProgramToolBox::KNOWN_PROGRAM_TYPES.keys).
        uniq.map { |program_type| [I18n.t("values.program_type.#{program_type}"), program_type] }
  end

  def program_can_retranslator?
    resource.can_retranslate_port? && can?(:retranslate, Port) && !Retranslator.active?
  end
end