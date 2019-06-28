require 'database_tools'
class Instance
  class CreateDatabaseUserService # Выбрать и создать пользователя БД для инстанса
    include DatabaseTools

    def initialize(instance_arg)
      @instance = instance_arg
      @database_users = get_database_users_list(ActiveRecord::Base.connection)
      raise ArgumentError, I18n.t('activerecord.errors.exceptions.instance.create_database_user_service.'+
                                  'argument_error.need_name_arg') if instance.name.blank?
    end

    def call
      base_user_name = create_base_user_name
      result = base_user_name
      number = 1
      while database_user_exists?(result)
        result = "#{base_user_name}_#{number}"
        number += 1
      end
      result
    end

    private
    attr_accessor :database_users, :instance

    def database_user_exists?(database_user)
      database_users.include?(database_user)
    end

    def create_base_user_name
      instance.name.gsub('-', '_')
    end
  end
end
