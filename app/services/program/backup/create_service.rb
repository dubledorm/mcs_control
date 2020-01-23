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
        begin
          stored_file_record = create_stored_file_record
          tmp_file = create_backup

          save_backup_to_store(tmp_file, stored_file_record)
        rescue RunBackupError => e
          save_error_to_store(e.message + " Error code = #{$?}", stored_file_record)
        end
      end

      private

      attr_accessor :program, :user

      def create_backup
        tmp_file = FileTools::create_tmp_file
        #cmd = "pg_dump -F c -v --dbname=#{pg_dump_dbname} -f #{tmp_file.path}"
        cmd = pg_dump_cmd(tmp_file)
        stdout_result = `#{cmd} 2>&1`

        raise RunBackupError, I18n.t('activerecord.errors.exceptions.program.backup.run_backup_error',
                                     cmd: cmd, error: stdout_result) unless $?.success?
        tmp_file
      end

      def create_stored_file_record
        file_name = bkp_file_name
        StoredFile.create!(program: program,
                           admin_user: user,
                           filename: file_name,
                           description: I18n.t('messages.backup_file_description',
                                               program_name: program.identification_name,
                                               dt: Time.current),
                           state: :creating,
                           content_type: :backup
        )
      end

      def save_backup_to_store(tmp_file, stored_file_record)
        ActiveRecord::Base.transaction do
          stored_file_record.state = :exists
          stored_file_record.file.attach(io: File.open(tmp_file.path), filename: stored_file_record.filename)
          stored_file_record.save
        end
        stored_file_record
      end

      def save_error_to_store(message, stored_file_record)
        stored_file_record.state = :fail
        stored_file_record.description = message
        stored_file_record.save
        stored_file_record
      end

      def bkp_file_name
        "#{program.database_name}_#{Time.current}.sql"
      end

      def pg_dump_dbname
        user_name = program.instance.db_user_name.downcase
        password = program.instance.db_user_password
        host = get_database_host
        port = get_database_port
        db_name = program.database_name
        "postgresql://#{user_name}:#{password}@#{host}:#{port}/#{db_name}"
      end

      def pg_dump_cmd(tmp_file)
        user_name = get_database_user #program.instance.db_user_name.downcase
        password = get_database_password #program.instance.db_user_password
        host = get_database_host
        db_name = program.database_name
        cmd = "export PGPASSWORD='#{password}'"
        cmd += ' && '
        cmd += "pg_dump -F c -v -U #{user_name} -h #{host} #{db_name} -f #{tmp_file.path}"
        cmd += ' && '
        cmd += "export -n PGPASSWORD"
        cmd
      end
    end
  end
end
