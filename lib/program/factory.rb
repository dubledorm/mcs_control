require 'database_name'
require 'infosphera_tools'
class Program
  class Factory
    extend DatabaseName
    extend InfospheraTools

    def self.build_and_create_db(instance, program_type, need_database_create, additional_name = nil)
      program = Program.new(instance: instance,
                            program_type: program_type,
                            additional_name: additional_name,
                            db_status: 'undefined')

      program.identification_name = make_identification_name(instance.name, program_type, additional_name)

      if need_database_create
        Program::DatabaseControl::CreateDatabase::build(program) if need_database?(program_type)
      else
        # TODO внести сюда проверку на существование базы и изменение статуса
      end

      program.save

      add_ports(program)
      Rails.logger.info 'Created program ' + program.identification_name
      return program
    end


    private

      def self.add_ports(program)
        program.default_ports_create.each do |port_type, quentity|
          (1..quentity).each do
            port_number = Port::FindFreeService.new(port_type).call
            program.ports.create(port_type: port_type,
                                 number: port_number,
                                 db_status: 'undefined')
          end
        end
      end
    
      def self.need_database?(program_type)
        program_type != 'dcs-dev'
      end
  end
end
