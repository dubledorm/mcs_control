module NginxConfig
  def self.config
    @@config ||= {}
  end

  def self.config=(hash)
    @@config = hash
  end

  PORT_TYPES_RANGES = { http: :http_ports_range, tcp: :stream_ports_range }


  # Проверить правильность заполнения массива границ портов
  # Проверяем в пределах одного массива
  def self.check_port_ranges(port_ranges)
    result = port_ranges.find_all{ |range| range.count != 2 }.inject([]){ |r, range| r << range} # Проверяем, что границы по две
    return result unless result.count.zero?

    result = port_ranges.find_all{ |range| range[0].class != Integer || range[1].class != Integer }.inject([]){ |r, range| r << range} # Проверяем, что это числа
    return result unless result.count.zero?

    result = port_ranges.find_all{ |range| range[0] >= range[1] }.inject([]){ |r, range| r << range} # Проверяем, что левая граница меньше правой
    return result unless result.count.zero?

    # Проверяем пересечение
    find_intercepts(port_ranges).inject([]){ |r, range| r << range}
  end

  def self.find_intercepts(port_ranges)
    port_ranges.find_all{ |range| has_intercepts?(range, except(range, port_ranges))}
  end

  # Вернуть самый левый порт из всех диапазонов в соответствии с типом
  def self.first_port(port_type)
    NginxConfig.config[PORT_TYPES_RANGES[port_type]][0][0]
  end

  def self.ranges(port_type)
    NginxConfig.config[PORT_TYPES_RANGES[port_type]]
  end

  private

  def self.has_intercepts?(range, ranges) # range пересекается с любым из ranges
    ranges.any?{ |elem| between?(range[0], elem) || between?(range[1], elem)}
  end

  def self.between?(value, range) # value находится между range[0] и range[1]
    value >= range[0] && value <= range[1]
  end

  def self.except(range, ranges)
    ranges.find_all{ |elem| elem != range }
  end
end