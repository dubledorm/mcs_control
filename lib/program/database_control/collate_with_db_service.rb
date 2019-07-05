require 'database_tools'
require 'infosphera_sql'
require 'infosphera_tools'

class Program
  module DatabaseControl
    class CollateWithDbService  # Сравнить записи в управляющей БД с реальными БД, проставить db_status.
      # При необходимости, создавать объекты в управляющей БД
      include DatabaseTools
      include InfospheraSql
      include InfospheraTools

      def initialize(program)
        @program = program
      end

      def call
        config   = Rails.configuration.database_configuration
        connection = get_custom_connection('temporary',
                                           config[Rails.env]['host'],
                                           config[Rails.env]['port'],
                                           program.database_name,
                                           config[Rails.env]["admin_username"],
                                           config[Rails.env]["admin_password"])
    #    ports = get_all_ports_of_uspd(connection)
        close_custom_connection
   #     ports.each do |port|
   #       check_and_create_port(port)
   #     end
      end

      private
      attr_accessor :program

      def check_and_create_port(port)
        program.ports.create!(number: port['input_value'],
                              instance: program.instance,
                              port_type: get_port_type(program.sym_program_type)
        ) if get_port_type(program.sym_program_type).present?
      end
    end
  end
end
