require 'database_tools'
require 'database_name'
require 'infosphera_tools'

# Сравнить записи в управляющей БД с реальными БД, проставить db_status.
# При необходимости, создавать объекты в управляющей БД
class Instance
  module DatabaseControl
    class CollateWithDbService < CollateBaseService
      include DatabaseTools
      include DatabaseName
      include InfospheraTools

      private
        def get_there_object_list(parent_object)
          get_database_list(ActiveRecord::Base.connection).
              find_all{|database_name| database_name =~ regexp_for_prefix(parent_object.name)}
         end

        def get_here_object_list(parent_object)
          parent_object.programs.map{|program| program.database_name}
        end

        def add_object_to_us(object_value, db_status)
          parent_object.programs.create!(program_type: get_program_type_to_s(object_value),
                                         database_name: object_value,
                                         identification_name: get_identification_name(parent_object, object_value),
                                         db_status: db_status.to_s)

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
