require 'database_tools'
require 'generate_password'

class Instance
  module DatabaseControl
    class CreateUser
      extend DatabaseTools
      extend GeneratePassword

      def self.build(instance)
        instance.db_user_name = Instance::DatabaseControl::DecideOnDbUserService.new(instance).call
        instance.db_user_password = GeneratePassword::generate_password(8)
        create_user(ActiveRecord::Base.connection, instance.db_user_name, instance.db_user_password)
      end
    end
  end
end
