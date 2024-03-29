require 'database_tools'
require 'database_name'

# Сравнить записи в управляющей БД с реальными БД, проставить db_status.
# При необходимости, создавать объекты в управляющей БД
class Instance
  module DatabaseControl
    class CollateWithDbService < CollateBaseService
      include DatabaseTools
      include DatabaseName

      def call
        Rails.logger.debug 'CollateWithDbService call'
        super
        Rails.logger.debug 'CollateWithDbService call dcs_dev_only.count = ' + parent_object.programs.dcs_dev_only.count.to_s
        return if parent_object.programs.dcs_dev_only.count > 0
        Program::Factory::build_and_create_db(parent_object, 'dcs-dev', false)
        Rails.logger.debug 'CollateWithDbService created dcs-dev'
        parent_object.reload
      end

      private
        def get_there_object_list(parent_object)
          get_database_list(ActiveRecord::Base.connection).
              find_all{|database_name| database_name =~ regexp_for_prefix(parent_object.name)}
         end

        def get_here_object_list(parent_object)
          parent_object.programs.map{|program| program.database_name}
        end

        def add_object_to_us(object_value, db_status)
          Rails.logger.debug "CollateWithDbService 11111111 object_value = #{object_value}"

          if (object_value == 'mc_chicken_2')
            additional_name = '2'
            identification_name = make_identification_name(parent_object.name,
                                                           get_program_type_to_s(object_value),
                                                           additional_name)
          else
            identification_name = get_identification_name(parent_object, object_value)
            additional_name = get_additional_name(object_value)
            additional_name = additional_name.nil? ? '' : additional_name
          end

          Rails.logger.debug "CollateWithDbService 11111111 additional_name = #{additional_name}"
          program = parent_object.programs.create!(program_type: get_program_type_to_s(object_value),
                                         database_name: object_value,
                                         identification_name: identification_name,
                                         additional_name: additional_name,
                                         db_status: db_status.to_s)
          return unless program.port_type == :http
          Rails.logger.debug "CollateWithDbService 11111111 before getPort"

          # Пробуем получить для программы порт
          program_port = Program::Nginx::GetPortFromHttpConfService::new(program).call
          return if program_port == 0
          Rails.logger.debug "CollateWithDbService 11111111 program_port = #{program_port}"

          program.ports.create!(port_type: 'http',
                                number: program_port,
                                db_status: 'everywhere_exists')
        end

        def set_object_db_status(object_value, db_status)
          program = parent_object.programs.where(database_name: object_value).first
          program.db_status = db_status
          program.save!
        end

        def get_identification_name(instance, database_name)
          make_identification_name(instance.name, get_program_type_to_s(database_name), get_additional_name(database_name))
        end
    end
  end
end
