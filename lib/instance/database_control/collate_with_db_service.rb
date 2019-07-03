require 'database_tools'

class Instance
  module DatabaseControl
    class CollateWithDbService
      include DatabaseTools

      def initialize(instance)
        @instance = instance
      end

      def call
        database_list = get_database_list(ActiveRecord::Base.connection).
            find_all{|database_name| database_name =~ /^#{@instance.database_prefix}/}

        # Проверяем, что для каждой программы есть база данных
        instance.programs.each do |program|
          if database_list.include?(program.database_name)
            program.db_status = 'everywhere_exists'
          else
            program.db_status = 'only_here_exists'
          end
        end

        # Проверяем случай когда есть база данных, но нет программы
        (database_list - instance.programs.map{|program| program.database_name}).each do |database_name|
          #TODO создать программу по имени БД
        end
      end

      private
        attr_accessor :instance
    end
  end
end
