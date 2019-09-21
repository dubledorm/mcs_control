# encoding: UTF-8
require 'program_type_characteristic'

module ProgramTypes
  class DcsDevProgramType < ProgramTypeCharacteristic
    def can_add_port?
      true
    end

    def can_collate_with_db?
      true
    end

    def port_type
      :tcp
    end

    def default_ports_create
      { tcp: 1 }
    end
  end

  class Pf2ProgramType < ProgramTypeCharacteristic
    def port_type
      :tcp
    end

    def default_ports_create
      { tcp: 2 }
    end

    def after_create(program)
      Pf2::PrepareService::new(program).call
    end
  end

  class DcsCliProgramType < ProgramTypeCharacteristic; end

  class OpProgramType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end
  end

  class McProgramType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end
  end
end