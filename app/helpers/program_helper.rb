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
    instance = resource.instance
    except_list = instance.programs.map(&:program_type).uniq - [ 'mc' ]
    except_list = except_list + [ 'pf2' ] unless can_add_retranslator?
  #  except_list = except_list + [ 'pp-router' ] unless can_add_pp_router?
  #  except_list = except_list + [ 'pp-web' ] unless can_add_pp_web?
    except_list = except_list.uniq

    (ProgramToolBox::KNOWN_PROGRAM_TYPES.keys - except_list).
        uniq.map { |program_type| [I18n.t("values.program_type.#{program_type}"), program_type] }
  end

  def program_can_retranslator?
    resource.can_retranslate_port? && can?(:retranslate, Port) && !Retranslator.active?
  end

  def can_add_retranslator?
    Program.all.pf2_only.count == 0
  end

  def can_add_pp_router?
    Program.all.pp_router_only.count == 0
  end

  def can_add_pp_web?
    Program.all.pp_web_only.count == 0
  end
end