module DatabaseTools

  def get_database_list( connection ) # Вернуть список существующих баз данных
    # noinspection SpellCheckingInspection
    database_names_hash = connection.execute('select datname from pg_database;')
    database_names_hash.values
  end

  def create_database( connection, database_name )
    connection.execute("create database #{database_name}")
  end

  def drop_database( connection, database_name )
    connection.execute("drop database #{database_name}")
  end
end
