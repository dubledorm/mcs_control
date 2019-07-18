require 'custom_active_record'
module DatabaseTools

  def get_database_list( connection ) # Вернуть список существующих баз данных
    # noinspection SpellCheckingInspection
    database_names_hash = connection.execute('select datname from pg_database;')
    database_names_hash.values.flatten
  end

  def create_database( connection, database_name )
    connection.execute("create database #{database_name}")
    Rails.logger.info 'Created database ' + database_name
  end

  def drop_database( connection, database_name )
    connection.execute("drop database #{database_name}")
    Rails.logger.info 'Deleted database ' + database_name
  end

  def get_database_users_list( connection )
    database_users_hash = connection.execute('select usename from pg_shadow;')
    database_users_hash.values.flatten
  end

  def create_user( connection, user_name, user_password = '')
    connection.execute("create user #{user_name} with password '#{user_password}'")
    Rails.logger.info 'Created database user ' + user_name
  end

  def drop_user( connection, user_name)
    connection.execute("drop user #{user_name}")
    Rails.logger.info 'Deleted database user ' + user_name
  end

  def db_user_exists?(db_user_name)
    return false if db_user_name.blank?
    get_database_users_list(ActiveRecord::Base.connection).include?(db_user_name)
  end

  def grant_all_privileges( connection, database_name, user_name)
    connection.execute("grant all privileges on database #{database_name} to #{user_name};")
    Rails.logger.info 'Granted privileges on database ' + database_name + 'to user ' + user_name
  end

  def get_custom_connection(identifier, host, port, dbname, dbuser, password)
    CustomActiveRecord.establish_connection(:adapter=>'postgresql', :host=>host, :port=>port, :database=>dbname,
                                            :username=>dbuser, :password=>password)
    return CustomActiveRecord.connection
  end

  def close_custom_connection
    CustomActiveRecord.connection.disconnect!
  end
end
