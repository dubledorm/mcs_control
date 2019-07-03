class Instance
  class Factory

    def self.build(name)
      instance = Instance.new(name: name, db_status: 'undefined')
      Instance::DatabaseControl::DbPrepare.build(instance)
      instance.save

      Program::Factory::build(instance, 'mc')
      Program::Factory::build(instance, 'op')
      Program::Factory::build(instance, 'dcs-dev')
      Program::Factory::build(instance, 'dcs-cli')

      return instance
    end
  end
end
