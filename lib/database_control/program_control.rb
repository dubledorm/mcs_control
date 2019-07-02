require 'database_tools'

module DatabaseControl
  class ProgramControl < DatabaseControl::Base
    include DatabaseTools

    attr_accessor :program

    def initialize(instance, program_type, additional_name = nil)
      @program = Program.new(instance: instance,
                             program_type: program_type,
                             additional_name: additional_name)
    end

    def prepare
      program.set_identification_name
      program.database_name = Program::DecideOnDbNameService.new(program).call
    end

    def call
      create_database( ActiveRecord::Base.connection, program.database_name )
      grant_all_privileges( ActiveRecord::Base.connection, program.database_name, program.instance.db_user_name)
      program.save
    end
  end
end
