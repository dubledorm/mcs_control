module ApplicationHelper

  def str_to_sym(value_str)
    value_str.parameterize.underscore.to_sym
  end

  # noinspection RubyStringKeysInHashInspection
  def str_to_bool(value_str)
    { nil => false, 'false' => false, 'true' => true}[value_str]
  end

  def test_point_exception(enable = false)
    # Эта функция используется для тестов. На тесте будет заменяться на Exception
    raise StandardError, 'Test exception message' if test_point_exception_enable? || enable
  end

  def test_point_exception_enable?
    false
  end

  def current_user
    current_admin_user
  end

  def retranslator_menu_label
    return '' unless Retranslator::active?
    "#{Retranslator::retranslator_replacement_port} : выключить"
  end

  def retranslator_switch_off_url
    return '' unless Retranslator::active?
    retranslator_port = Retranslator::retranslator_replacement_port
    return '' if retranslator_port.blank?
    port = Port.where(number: retranslator_port).first
    Rails.application.routes.url_helpers.retranslator_off_admin_program_port_path(program_id: port.program_id, id: port.id)
  end

  def program_types_with_translate
    ProgramToolBox::KNOWN_PROGRAM_TYPES.keys.map { |program_type| [I18n.t("values.program_type.#{program_type}"), program_type] }
  end
end
