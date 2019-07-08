class Instance
  class Factory

    def self.build_and_create_db(instance)
      Instance::DatabaseControl::CreateUser.build(instance)
      instance.db_status = 'undefined'
      instance.save!

      Program::Factory::build_and_create_db(instance, 'mc')
      Program::Factory::build_and_create_db(instance, 'op')
      Program::Factory::build_and_create_db(instance, 'dcs-dev')
      Program::Factory::build_and_create_db(instance, 'dcs-cli')

      instance.db_status = 'everywhere_exists'
      instance.save!
      return instance
    end
  end
end
