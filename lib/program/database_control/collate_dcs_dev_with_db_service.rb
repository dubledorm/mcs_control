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
        program_op = parent_object.instance.programs.op_only.first
        raise StandardError, I18n.t('activerecord.errors.exceptions.program.' +
                                     'collate_dcs_dev_with_db_service.not_found_op') if program_op.nil?

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
        return ports
      end

      def get_here_object_list(parent_object)
        raise ArgumentError, message: I18n.t('activerecord.errors.exceptions.program.' +
                                             'collate_dcs_dev_with_db_service.only_dcs_dev') if parent_object.program_type != program_type_to_s(:dcs_dev)
        parent_object.ports.map{ |port| port.number }
      end

      def add_object_to_us(object_value, db_status)
        parent_object.ports.create!(number: object_value['input_value'].to_i,
                                    port_type: parent_object.port_type.to_s,
                                    # port_type: get_port_type(parent_object.sym_program_type).to_s,
                                    db_status: db_status
                                   )
      end

      def set_object_db_status(object_value, db_status)
        # Найти по номеру порт и поменять значение
        port = parent_object.ports.where(number: object_value).first
        port.db_status = db_status
        port.save!
      end

      def get_there_value(object_value)
        object_value['input_value'].to_i
      end
    end
  end
end
