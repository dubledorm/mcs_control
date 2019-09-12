require 'nginx_config'

NginxConfig.config = YAML.load_file("config/nginx_config.yml")[Rails.env].symbolize_keys
