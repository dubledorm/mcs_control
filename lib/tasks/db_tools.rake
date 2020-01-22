require 'database_tools'

namespace :db_tools do
  desc 'Проверить на все базы программ наличие указанного пользователя и проставить права на базу'
  task :repair_users => :environment do
    extend DatabaseTools

    Program.all.each do |program|
      begin
        ap(program.identification_name)
        next unless program.need_database?
        next if program.database_name.blank?
        next if program.instance.db_user_name.blank?

        db_user = program.instance.db_user_name
        db_password = program.instance.db_user_password

        create_user(ActiveRecord::Base.connection, db_user, db_password) unless db_user_exists?(db_user.downcase)
        grant_all_privileges( ActiveRecord::Base.connection, program.database_name, db_user.downcase)

      rescue StandardError => e
        Rails.logger.error("#{program.identification_name} #{e.message}")
        ap("ERROR #{program.identification_name} #{e.message}")
      end
    end
  end
end