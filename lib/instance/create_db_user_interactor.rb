require 'database_tools'
require 'generate_password'
class Instance

  DB_USER_PASSWORD_LENGTH = 8

  # noinspection SpellCheckingInspection
  class CreateDbUserInteractor # Выбрать и создать пользователя в базе данных
    include Interactor
    include DatabaseTools
    include GeneratePassword

    def call
      begin
        context.instance.db_user_name = Instance::DecideOnDbUserService.new(context.instance).call
        context.instance.db_user_password = generate_password(Instance::DB_USER_PASSWORD_LENGTH)
        create_user(ActiveRecord::Base.connection, context.instance.db_user_name, context.instance.db_user_password)
      rescue StandardError => e
        context.fail!(message: I18n.t('activerecord.errors.exceptions.instance.create_db_user_interactor.'+
                                          'standard_error.cause_of_error', error_message: e.message))
      end
    end
  end
end
