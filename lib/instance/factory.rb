class Instance
  class Factory

    def self.build(name)
      instance = Instance.new(name: name, db_status: 'undefined')
      Instance::DatabaseControl::DbPrepare.build(instance)
      instance.save!

      Program::Factory::build_and_create_db(instance, 'mc')
      Program::Factory::build_and_create_db(instance, 'op')
      Program::Factory::build_and_create_db(instance, 'dcs-dev')
      Program::Factory::build_and_create_db(instance, 'dcs-cli')

      return instance
    end
  end
end
