require 'database_tools'

class Program
  class Destructor
    extend DatabaseTools

    def self.destroy_and_drop_db(program)
      drop_database(ActiveRecord::Base.connection, program.database_name) unless program.database_name.blank?
      program.destroy
    end
  end
end