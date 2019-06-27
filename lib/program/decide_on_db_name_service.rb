require 'database_tools'
class Program
  class DecideOnDbNameService # Выбрать имя базы данных для программы
    include DatabaseTools

    def initialize( program_arg )
      @program = program_arg
      @database_names = get_database_list(ActiveRecord::Base.connection)
    end

    def call
      base_name = program.identification_name.gsub('-', '_')
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
    end
end
