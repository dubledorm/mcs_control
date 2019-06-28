module DatabaseTools

  def get_database_list( connection ) # Вернуть список существующих баз данных
    # noinspection SpellCheckingInspection
    database_names_hash = connection.execute('select datname from pg_database;')
    database_names_hash.values.flatten
  end

  def create_database( connection, database_name )
    connection.execute("create database #{database_name}")
  end

  def drop_database( connection, database_name )
    connection.execute("drop database #{database_name}")
  end

  def get_database_users_list( connection )
    database_users_hash = connection.execute('select * from pg_shadow;')
    database_users_hash.values.flatten
  end

  def create_user( connection, user_name, user_password = '')
    connection.execute("create user #{user_name} with password '#{user_password}'")
  end
end
