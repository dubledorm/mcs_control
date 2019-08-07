require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module McsControl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.default_locale = :ru
    I18n.config.enforce_available_locales = false
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.autoload_paths += %W(#{config.root}/lib)
    config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
     config.logger.formatter = proc do | severity, datetime, progname, msg |
      "#{datetime}, #{severity}: #{msg}\n"
    end
  end
end
