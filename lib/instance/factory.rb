require 'database_tools'

class Instance
  class Factory
    extend DatabaseTools

    def self.build_and_create_db(instance)
      begin
        Instance::DatabaseControl::CreateUser::build(instance)
        instance.db_status = 'undefined'
        instance.save!

        Program::Factory::build_and_create_db(instance, 'mc')
        Program::Factory::build_and_create_db(instance, 'op')
        Program::Factory::build_and_create_db(instance, 'dcs-dev')
        Program::Factory::build_and_create_db(instance, 'dcs-cli')

        instance.db_status = 'everywhere_exists'
        instance.save!
        return instance
      rescue StandardError => e
        restore(instance)
        raise e
      end
    end

    def self.build(instance)
      begin
        Instance::DatabaseControl::CreateUser::build(instance)
        instance.db_status = 'undefined'
        instance.save!
        return instance
      rescue StandardError => e
        restore(instance)
        raise e
      end
    end

    private

      def self.restore(instance)
        if instance.persisted?
          Instance::Destructor::destroy_and_drop_db(instance)
          return
        end

        drop_user(ActiveRecord::Base.connection, instance.db_user_name) if db_user_exists?(instance.db_user_name)
      end
  end
end
