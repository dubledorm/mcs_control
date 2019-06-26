module DatabaseTools

  def get_database_list # Вернуть список существующих баз данных
    # noinspection SpellCheckingInspection
    database_names_hash = ActiveRecord::Base.connection.execute('select datname from pg_database;')
    database_names_hash.values
  end
end
