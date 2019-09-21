require 'database_tools'

class Program
  class Destructor
    extend DatabaseTools

    def self.destroy_and_drop_db(program)
      if program.created_db_myself?
        drop_database(ActiveRecord::Base.connection, program.database_name) if database_exists?(program.database_name)
      end
      program.destroy
    end

    private
      def self.database_exists?(database_name)
        return false if database_name.blank?
        get_database_list(ActiveRecord::Base.connection).include?(database_name)
      end
  end
end