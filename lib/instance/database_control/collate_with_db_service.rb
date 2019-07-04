require 'database_tools'
require 'database_name'

class Instance
  module DatabaseControl
    class CollateWithDbService  # Сравнить записи в управляющей БД с реальными БД, проставить db_status.
                                # При необходимости, создавать объекты в управляющей БД
      include DatabaseTools
      include DatabaseName

      def initialize(instance)
        @instance = instance
      end

      def call
        database_list = get_database_list(ActiveRecord::Base.connection).
            find_all{|database_name| database_name =~ /^#{database_prefix(@instance.name)}/}

        # Проверяем, что для каждой программы есть база данных
        instance.programs.each do |program|
          if database_list.include?(program.database_name)
            program.db_status = 'everywhere_exists'
          else
            program.db_status = 'only_here_exists'
          end
          program.save!
        end

        # Проверяем случай когда есть база данных, но нет программы
        (database_list - instance.programs.map{|program| program.database_name}).each do |database_name|
          instance.programs.create!(program_type: get_program_type_to_s(database_name),
                                    database_name: database_name,
                                    identification_name: get_identification_name(instance, database_name),
                                    db_status: 'only_there_exists')
        end
      end

      private
        attr_accessor :instance

      def get_identification_name(instance, database_name)
        make_identification_name(instance.name, get_program_type_to_s(database_name), get_additional_name(database_name))
      end
    end
  end
end
