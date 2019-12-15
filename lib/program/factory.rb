require 'database_name'
require 'application_helper'

class Program
  class Factory
    extend DatabaseName
    extend ApplicationHelper

    def self.build_and_create_db(instance, program_type, need_database_create, additional_name = nil)
      program = Program.new(instance: instance,
                            program_type: program_type,
                            additional_name: additional_name,
                            db_status: 'undefined')
      begin
        program.identification_name = make_identification_name(instance.name, program_type, additional_name)

        if need_database_create
          if program.need_database?
            Program::DatabaseControl::CreateDatabase::build(program)
            program.created_db_myself = true
          end
        else
          # TODO внести сюда проверку на существование базы и изменение статуса
        end

        program.save!

        test_point_exception

        if need_database_create
          add_ports(program)
          program.after_create
        end
        Rails.logger.info 'Created program ' + program.identification_name
        return program
      rescue StandardError => e
        Program::Destructor::destroy_and_drop_db(program) if program && program.persisted?
        raise e
      end
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
    
      # def self.need_database?(program_type)
      #   !%w(dcs-dev pf2 pp-web).include?(program_type)
      # end
  end
end
