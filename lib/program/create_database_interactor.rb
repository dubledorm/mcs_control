require 'database_tools'
class Program
  # noinspection SpellCheckingInspection
  class CreateDatabaseInteractor
    include Interactor
    include DatabaseTools

    def call
      begin
        create_database( ActiveRecord::Base.connection, context.program.database_name )
      rescue StandardError => e
        context.fail!(message: I18n.t('activerecord.errors.exceptions.program.create_database_interactor.'+
                                          'stanadrd_error.cause_of_error', error_message: e.message))
      end
    end
  end
end
