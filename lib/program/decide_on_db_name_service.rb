require 'database_tools'
require 'database_name'
class Program
  class DecideOnDbNameService # Выбрать имя базы данных для программы
    include DatabaseTools
    include DatabaseName

    class DoNotNeedDatabase < StandardError; end

    def initialize( program_arg )
      @program = program_arg
      @database_names = get_database_list(ActiveRecord::Base.connection)
      raise ArgumentError, I18n.t('activerecord.errors.exceptions.program.decide_on_db_name_service.argument_error.' +
                                  'type_and_instance') if program.instance.nil? || program.program_type.blank?
      raise DoNotNeedDatabase, I18n.t('activerecord.errors.exceptions.program.decide_on_db_name_service.'+
                                      'do_not_need_database.') if program.program_type.to_s == 'dcs-dev'
    end

    def call
      base_name = create_db_name
      result = base_name
      number = 1
      while db_name_exists?(result)
        result = "#{base_name}_#{number}"
        number += 1
      end
      result
    end

    private
      attr_accessor :program, :database_names

      def db_name_exists?(db_name)
        database_names.include?(db_name)
      end

      def create_db_name
        create_database_name(program.instance.name, program.program_type, program.additional_name)
      end
    end
end
