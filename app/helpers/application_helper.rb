module ApplicationHelper

  REGEXP_DATABASE_URL = /(?<protocol>[a-zA-Z_\d\.]+)\:\/\/(?<username>[a-zA-Z_\d]+)\:(?<password>[a-zA-Z_\d]+)\@(?<host>[a-zA-Z_\d\.]+)\//

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

  def retranslator_menu_label(retranslator)
    return I18n.t('menu.retranslate_dont_work', port_number: retranslator.port_to) unless retranslator.active?
    I18n.t('menu.retranslate_off', port_number: retranslator.replacement_port)
  end

  def retranslator_switch_off_url(retranslator)
    default_url = Rails.application.routes.url_helpers.admin_listport_path
    return default_url unless retranslator&.active?

    retranslator_port = retranslator.replacement_port
    return default_url if retranslator_port.blank?

    port = Port.where(number: retranslator_port).first
    Rails.application.routes.url_helpers.retranslator_off_admin_program_port_path(program_id: port.program_id, id: port.id)
  end

  def program_types_with_translate
    ProgramToolBox::KNOWN_PROGRAM_TYPES.keys.map { |program_type| [I18n.t("values.program_type.#{program_type}"), program_type] }
  end

  def get_database_host
    host = REGEXP_DATABASE_URL.match(ENV['DATABASE_URL'])['host'] unless ENV['DATABASE_URL'].blank?
    return host unless host.nil?

    config   = Rails.configuration.database_configuration
    host = config[Rails.env]['host']
    host = 'localhost' if host.blank?
    host
  end

  def get_database_user
    username = REGEXP_DATABASE_URL.match(ENV['DATABASE_URL'])['username'] unless ENV['DATABASE_URL'].blank?
    return username unless username.nil?

    config   = Rails.configuration.database_configuration
    username = config[Rails.env]['admin_username']
    raise StandardError, 'Could not find database username' if username.blank?
    username
  end

  def get_database_password
    password = REGEXP_DATABASE_URL.match(ENV['DATABASE_URL'])['password'] unless ENV['DATABASE_URL'].blank?
    return password unless password.nil?

    config   = Rails.configuration.database_configuration
    password = config[Rails.env]['admin_password']
    raise StandardError, 'Could not find database password' if password.nil?
    password
  end

  def get_database_port
    '5432'
  end
end
