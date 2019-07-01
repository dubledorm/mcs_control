require 'database_tools'
class Program
  # noinspection SpellCheckingInspection
  class CreateDatabaseInteractor
    include Interactor
    include DatabaseTools

    def call
      begin
        raise ArgumentError, message: I18n.t('activerecord.errors.exceptions.program.create_database_interactor.' +
                                                 'argument_error.database_name') if context.program.database_name.blank?
        raise ArgumentError, message: I18n.t('activerecord.errors.exceptions.program.create_database_interactor.' +
                                                 'argument_error.database_user_name') if context.program.instance.db_user_name.blank?
        
        create_database( ActiveRecord::Base.connection, context.program.database_name )
        grant_all_privileges( ActiveRecord::Base.connection, context.program.database_name, context.program.instance.db_user_name)
      rescue StandardError => e
        context.fail!(message: I18n.t('activerecord.errors.exceptions.program.create_database_interactor.'+
                                          'standard_error.cause_of_error', error_message: e.message))
      end
    end
  end
end
