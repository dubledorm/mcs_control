module InfospheraTools

  def get_port_type(program_type_sym) # Возвращает тип порта, необходимый для программы
    { mc: :http,
      op: :http,
      dcs_dev: :tcp,
      dcs_cli: nil }[program_type_sym]
  end
end
