require 'database_tools'

class Program
  module DatabaseControl
    class DbPrepare
      include DatabaseTools

      def self.build(program)
        program.set_identification_name
        program.database_name = Program::DecideOnDbNameService.new(program).call if program.program_type != 'dcs-dev'

        create_database( ActiveRecord::Base.connection, program.database_name )
        grant_all_privileges( ActiveRecord::Base.connection, program.database_name, program.instance.db_user_name)
      end
    end
  end
end
