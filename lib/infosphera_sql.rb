module InfospheraSql

  # Получить все порты всех подключенных к сети УСПД системы
  def get_all_ports_of_uspd(connection)
    connection.execute('select d.input_value, d1.serial_number, m.device_type FROM device_object AS d ' +
                           'JOIN model_object mo ON d.model_object_uuid = mo.uuid ' +
                           'JOIN object_dict od ON mo.object_dict_uuid = od.uuid ' +
                           'JOIN device_logic_device dld ON dld.uuid = d.device_logic_device_uuid ' +
                           'JOIN device d1 ON dld.device_uuid = d1.uuid ' +
                           'JOIN model m ON d1.model_uuid = m.uuid ' +
                           'JOIN network_device nd ON nd.device_uuid = d1.uuid ' +
                           'WHERE od.uuid = 7 and m.device_type = 4;'
    )
  end
end
