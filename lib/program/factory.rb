require 'database_name'
class Program
  class Factory
    extend DatabaseName

    def self.build(instance, program_type, additional_name = nil)
      program = Program.new(instance: instance,
                            program_type: program_type,
                            additional_name: additional_name,
                            db_status: 'undefined')

      program.identification_name = make_identification_name(instance.name, program_type, additional_name)

      Program::DatabaseControl::DbPrepare.build(program) if need_database?(program_type)

      program.save

      port_type = get_port_type(program.sym_program_type)
      return program if port_type.blank?

      add_port(port_type, program)
      return program
    end

    private

      def self.get_port_type(program_type_sym) # Возвращает тип порта, необходимый для программы
        { mc: :http,
          op: :http,
          dcs_dev: :tcp,
          dcs_cli: nil }[program_type_sym]
      end

      def self.add_port(port_type, program)
        port_number = Port::FindFreeService.new(port_type).call
        program.ports.create(port_type: port_type,
                             number: port_number,
                             instance: program.instance,
                             db_status: 'undefined')
      end

      def self.need_database?(program_type)
        program_type != 'dcs-dev'
      end
  end
end
