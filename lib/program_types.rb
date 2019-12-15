# encoding: UTF-8
require 'program_type_characteristic'

module ProgramTypes
  class DcsDevProgramType < ProgramTypeCharacteristic
    def can_add_port?
      true
    end

    def can_delete_port?
      true
    end

    def can_retranslate_port?
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

    def need_database?
      false
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

    def need_database?
      false
    end
  end

  class TcpServerProgramType < ProgramTypeCharacteristic
    def port_type
      :tcp
    end

    def default_ports_create
      { tcp: 2 }
    end

    def need_database?
      false
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

    def http_prefix
      'operator'
    end
  end

  class McProgramType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end

    def http_prefix
      'mc'
    end
  end

  class DispProgramType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end

    def http_prefix
      'disp'
    end
  end

  class PpRouterType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end
  end

  class PpAdminType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end
  end

  class PpWebType < ProgramTypeCharacteristic
    def port_type
      :http
    end

    def default_ports_create
      { http: 1 }
    end

    def need_database?
      false
    end
  end
end