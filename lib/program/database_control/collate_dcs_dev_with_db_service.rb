require 'database_tools'
require 'infosphera_sql'
require 'infosphera_tools'

# Класс, для заполнения программы dcs-dev списком портов.
# Порты, используемые dcs-dev лежат в базе программы op.
# Поэтому, лезем в Instance, от него находим базу op, берём её database_name,
# подключаемся к ней и сравниваем список портов там и здесь
class Program
  module DatabaseControl
    class CollateDcsDevWithDbService < CollateBaseService
      include DatabaseTools
      include InfospheraSql
      include InfospheraTools

      def get_there_object_list(parent_object)
        # Находим программу :op
        program_op = parent_object.instance.programs.where(program_type: :op).first
        raise StandardError if program_op.nil?

        # Получаем список портов в Инфосфера
        config   = Rails.configuration.database_configuration
        connection = get_custom_connection('temporary',
                                           config[Rails.env]['host'],
                                           config[Rails.env]['port'],
                                           program_op.database_name,
                                           config[Rails.env]["admin_username"],
                                           config[Rails.env]["admin_password"])
        ports = get_all_ports_of_uspd(connection)
        close_custom_connection
        return ports.map{|port| port['input_value']}
      end

      def get_here_object_list(parent_object)
        raise ArgumentError if parent_object.program_type != program_type_to_s(:dcs_dev)
        parent_object.ports.map{ |port| port.number }
      end

      def add_object_to_us(object_value, db_status)
        parent_object.ports.create!(number: object_value.to_i,
                                    instance: parent_object.instance,
                                    port_type: get_port_type(parent_object.sym_program_type).to_s
                                   )
      end

      def set_object_db_status(object_value, db_status)
        # Найти по номеру порт и поменять значение
        port = parent_object.ports.where(number: object_value).first
        port.db_status = db_status
        port.save!
      end
    end
  end
end
