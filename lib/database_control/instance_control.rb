require 'database_tools'
require 'generate_password'

module DatabaseControl
  class InstanceControl < DatabaseControl::Base
    include DatabaseTools
    include GeneratePassword

    attr_accessor :instance

    DB_USER_PASSWORD_LENGTH = 8

    def initialize(name)
      @instance = Instance.new(name: name)
    end

    def prepare
      instance.db_user_name = Instance::DecideOnDbUserService.new(instance).call
      instance.db_user_password = generate_password(DB_USER_PASSWORD_LENGTH)
    end

    def call
      create_user(ActiveRecord::Base.connection, instance.db_user_name, instance.db_user_password)
      instance.save!
    end
  end
end
