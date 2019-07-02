class Program
  class Factory

    def self.build(instance, program_type, additional_name = nil)
      program = Program.new(instance: instance,
                            program_type: program_type,
                            additional_name: additional_name)
      # program_control = DatabaseControl::ProgramControl.new(instance, program_type, additional_name)
      # program_control.prepare
      # program_control.call
      # program = program_control.program
      Program::DatabaseControl::DbPrepare.build(program)
      program.save

      port_type = get_port_type(program.program_type.to_sym)
      return program if port_type.blank?

      add_port(port_type, program)
      return program
    end

    private

      def self.get_port_type(program_type_sym) # Возвращает тип порта, необходимый для программы
        { mc: :http,
          op: :http,
          'dcs-dev'.parameterize.underscore.to_sym => :tcp,
          'dcs-cli'.parameterize.underscore.to_sym => nil }[program_type_sym]
      end

      def self.add_port(port_type, program)
        port_number = Port::FindFreeService.new(port_type).call
        program.ports.create(port_type: port_type,
                             number: port_number,
                             instance: program.instance)
      end
  end
end
