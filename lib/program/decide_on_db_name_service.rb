require 'database_tools'
class Program
  class DecideOnDbNameService # Выбрать имя базы данных для программы
    include DatabaseTools

    def initialize( program_arg )
      @program = program_arg
      @database_names = get_database_list
    end

    def call
      result = "#{program.name}_#{program.program_type}"
      number = 1
      while db_name_exists?(result)
        result = "#{program.name}_#{program.program_type}_#{number}"
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
