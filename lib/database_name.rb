module DatabaseName
  REGEXP_DATABASE_NAME = /^(?<program_type>mc|op|dcs4)_(?<prefix>[a-zA-Z\d]+)(?:_(?<add_name>[a-zA-Z_\d]+?))??(?:_(?<digit>\d*))??$/.freeze
  REGEXP_DATABASE_NAME_PREFIX = '^(?<program_type>mc|op|dcs4)_(?<prefix>PREFIX_NAME)(?:_(?<add_name>[a-zA-Z_\d]+?))??(?:_(?<digit>\d*))??$'.freeze
  DATABASE_NAMES = { mc: 'mc', op: 'op', dcs_cli: 'dcs4'}.freeze

  def create_database_name(instance_name, program_type, additional_name)
    (DATABASE_NAMES[program_type.parameterize.underscore.to_sym] + '_' +
        instance_name +
        (additional_name.blank? ? '' : '_' + additional_name)).gsub('-','_').downcase
  end

  def get_program_type(database_name)  # Получить тип программы из имени базы данных
    program_type = REGEXP_DATABASE_NAME.match(database_name)[:program_type]
    DATABASE_NAMES.invert[program_type]
  end

  def get_program_type_to_s(database_name)  # Получить тип программы из имени базы данных
    get_program_type(database_name).to_s.gsub('_','-')
  end

  def get_database_prefix(database_name)  # Получить префикс из имени базы данных
    REGEXP_DATABASE_NAME.match(database_name)[:prefix]
  end

  def get_additional_name(database_name)  # Получить additional_name из имени базы данных
    REGEXP_DATABASE_NAME.match(database_name)[:add_name].to_s
  end

  def make_identification_name(instance_name, program_type, additional_name)
    "#{ instance_name }-#{ program_type.to_s.gsub('_','-') }#{ additional_name.blank? ? '' : '-' + additional_name }"
  end

  def database_prefix(instance_name)
    instance_name.gsub('-', '_')
  end

  def regexp_for_prefix(prefix) # Получить рег. эксп для отбора всех баз данных для определённого инмтанса. Имя инстанса - prefix
    Regexp.new REGEXP_DATABASE_NAME_PREFIX.gsub('PREFIX_NAME', prefix)
  end
end
