class Program
  module Backup
    class CreateService

      class NotDatabaseError < StandardError; end
      class RunBackupError < StandardError; end

      def initialize(program)
        @program = program
      end

      def call
        raise NotDatabaseError, I18n.t('activerecord.errors.exceptions.program.backup.no_database_error',
                                       program_name: program.identification_name) unless program.need_database?
        tmp_file = FileTools::create_tmp_file
        config   = Rails.configuration.database_configuration
        cmd = "pg_dump -F c -v -U #{program.instance.db_user_name} -h #{config[Rails.env]['host']} #{program.database_name} -f #{tmp_file.path}"
        result = system(cmd)

        raise RunBackupError, I18n.t('activerecord.errors.exceptions.program.backup.run_backup_error',
                                     cmd: cmd) if result.nil? || result == false
        tmp_file.path
      end

      private

      attr_accessor :program
    end
  end
end
