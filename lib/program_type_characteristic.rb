class ProgramTypeCharacteristic
  # Разрешать в интерфейсе добавлять порты
  def can_add_port?
    false
  end

  # Разрешать в интерфейсе удалять порты
  def can_delete_port?
    false
  end

  # Разрешать в интерфейсе переводить порт в режим ретрансляции
  def can_retranslate_port?
    false
  end

  # Разрешать сверять с БД
  def can_collate_with_db?
    false
  end

  # Тип портов добавляемых из интерфейса по кнопке "Добавить порт"
  def port_type
    nil
  end

  # Порты, которые необходимо создать сразу, при создании данного типа программы
  # Возвращается hash тип_порта=>кол-во
  def default_ports_create
    {}
  end

  # Действия, которые может быть надо выполнить после создания программы
  def after_create(program)

  end
end