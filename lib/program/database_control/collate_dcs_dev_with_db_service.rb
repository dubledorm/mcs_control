require 'database_tools'
require 'infosphera_sql'

# Класс, для заполнения программы dcs-dev списком портов.
# Порты, используемые dcs-dev лежат в базе программы op.
# Поэтому, лезем в Instance, от него находим базу op, берём её database_name,
# подключаемся к ней и сравниваем список портов там и здесь
class Program
  module DatabaseControl
    class CollateDcsDevWithDbService < CollateBaseService
      include DatabaseTools
      include InfospheraSql

      def get_there_object_list(parent_object)
        # Находим программу :op
        program_op = parent_object.instance.programs.op_only.first
        raise StandardError, I18n.t('activerecord.errors.exceptions.program.' +
                                     'collate_dcs_dev_with_db_service.not_found_op') if program_op.nil?

        # Получаем список портов в Инфосфера
        user_name = get_database_user #program.instance.db_user_name.downcase
        password = get_database_password #program.instance.db_user_password
        port = get_database_port
        host = get_database_host
        db_name = program_op.database_name

#        config   = Rails.configuration.database_configuration
#         Rails.logger.debug "get_there_object_list host = #{config[Rails.env]['host']} port = #{config[Rails.env]['port']}" +
#                                " database_name = #{program_op.database_name}" +
#                                " user_name = #{config[Rails.env]["admin_username"]} password = #{config[Rails.env]["admin_password"]}"

        Rails.logger.debug "get_there_object_list host = #{host} port = #{port}" +
                               " database_name = #{db_name}" +
                               " user_name = #{user_name} password = #{password}"

        connection = get_custom_connection('temporary',
                                           host,
                                           port,
                                           db_name,
                                           user_name,
                                           password)
        ports = get_all_ports_of_uspd(connection)
        close_custom_connection
        return ports
      end

      def get_here_object_list(parent_object)
        raise ArgumentError, message: I18n.t('activerecord.errors.exceptions.program.' +
                                             'collate_dcs_dev_with_db_service.only_dcs_dev') if parent_object.program_type != 'dcs-dev'
        parent_object.ports.map{ |port| port.number }
      end

      def add_object_to_us(object_value, db_status)
        parent_object.ports.create!(number: object_value['input_value'].to_i,
                                    port_type: parent_object.port_type.to_s,
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
