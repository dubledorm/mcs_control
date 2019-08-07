require 'database_tools'

class Instance
  class Destructor
    extend DatabaseTools

    def self.destroy_and_drop_db(instance)
      instance.programs.each do |program|
        Program::Destructor::destroy_and_drop_db(program)
        program.destroy
      end
      drop_user(ActiveRecord::Base.connection, instance.db_user_name) if db_user_exists?(instance.db_user_name)
      instance.destroy
    end
  end
end
