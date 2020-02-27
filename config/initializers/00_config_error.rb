class ConfigurationError < StandardError

  def initialize(message, config_file_name)
    my_message = message.blank? ? 'Undefined message' : message
    my_config_file_name = config_file_name.blank? ? 'Undefined config_file_name' : config_file_name
    error_str = "Configuration error in file #{my_config_file_name}: #{my_message}"

    ap('-------------------------------------------------')
    ap(error_str)
    ap('-------------------------------------------------')
    Rails.logger.error(error_str)
    super(error_str)
  end
end