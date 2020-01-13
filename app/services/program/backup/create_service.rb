class Program
  module Backup
    class CreateService

      class NotDatabaseError < StandardError; end
      class RunBackupError < StandardError; end

      def initialize(program, user)
        @program = program
        @user = user
      end

      def call
        raise NotDatabaseError, I18n.t('activerecord.errors.exceptions.program.backup.no_database_error',
                                       program_name: program.identification_name) unless program.need_database?
        tmp_file = create_backup

        save_backup_to_store(tmp_file)
      end

      private

      attr_accessor :program, :user

      def create_backup
        tmp_file = FileTools::create_tmp_file
        config   = Rails.configuration.database_configuration
        host = config[Rails.env]['host']
        host = 'localhost' if host.blank?
        cmd = "pg_dump -F c -v -U #{program.instance.db_user_name.downcase} -h #{host} #{program.database_name} -f #{tmp_file.path}"
        result = system(cmd)

        raise RunBackupError, I18n.t('activerecord.errors.exceptions.program.backup.run_backup_error',
                                     cmd: cmd) if result.nil? || result == false
        tmp_file
      end

      def save_backup_to_store(tmp_file)
        stored_file = nil
        file_name = bkp_file_name
        ActiveRecord::Base.transaction do
          stored_file = StoredFile.create!(program: program,
                                           admin_user: user,
                                           filename: file_name,
                                           description: I18n.t('messages.backup_file_description',
                                                               program_name: program.identification_name,
                                                               dt: Time.current),
                                           state: :exists,
                                           content_type: :backup
          )
          stored_file.file.attach(io: File.open(tmp_file.path), filename: file_name)
        end

        stored_file
      end

      def bkp_file_name
        "#{program.database_name}_#{Time.current}.sql"
      end
    end
  end
end
