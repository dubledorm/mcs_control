require 'nginx_config'

#NginxConfig.config = YAML.load_file("config/nginx_config.yml")[Rails.env].symbolize_keys
NginxConfig.config = YAML.load(ERB.new(File.read("#{Rails.root.to_s}/config/nginx_config.yml")).result)[Rails.env].symbolize_keys


# Проверяем наличие
raise ConfigurationError.new('Need http_ports_range',
                             'config/nginx_config.yml')  if NginxConfig.config[:http_ports_range].blank?
raise ConfigurationError.new('Need stream_ports_range',
                             'config/nginx_config.yml')  if NginxConfig.config[:stream_ports_range].blank?

# Проверяем правильность заполнения
errors = NginxConfig::check_port_ranges(NginxConfig.config[:http_ports_range])
raise ConfigurationError.new("Error in parameter http_ports_range. Please, check the next values: #{errors}",
                             'config/nginx_config.yml')  unless errors.count == 0

errors = NginxConfig::check_port_ranges(NginxConfig.config[:stream_ports_range])
raise ConfigurationError.new("Error in parameter stream_ports_range. Please, check the next values: #{errors}",
                             'config/nginx_config.yml')  unless errors.count == 0

# Проверяем пересечения
errors = NginxConfig::find_intercepts(NginxConfig.config[:http_ports_range] + NginxConfig.config[:stream_ports_range])
raise ConfigurationError.new("Found intercection between http_ports_range and stream_ports_range. Please, check the next values: #{errors}",
                             'config/nginx_config.yml')  unless errors.count == 0
