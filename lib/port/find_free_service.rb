class Port
  class FindFreeService  # Найти и вернуть следующий свободный порт
    RANGE_OF_NUMBER = { http: { left_range: 30000, right_range: 31000 },
                        tcp: { left_range: 31001, right_range: 64000 }
    }.freeze

    def initialize( port_type_arg )
      if ![:http, :tcp].include?(port_type_arg)
        raise ArgumentError.new(I18n.t('activerecord.errors.services.find_free_service.bad_argument'))
      end

      @port_type = port_type_arg;
      @ports = Port.order(:number).pluck(:number)
    end

    def call
      return RANGE_OF_NUMBER[@port_type][:left_range] if @ports.size == 0

      new_port = find_empty_place

      return new_port if new_port
      raise StandardError.new(I18n.t('activerecord.errors.services.find_free_service.bring_range_of_diapason'))
    end
    
  private
    attr_accessor :port_type, :ports


    def find_empty_place # возвращает свободное место среди уже выделенных портов, или nil, если такого нет
      empty_places = (RANGE_OF_NUMBER[@port_type][:left_range]..RANGE_OF_NUMBER[@port_type][:right_range]).to_a - ports
      return empty_places[0] if empty_places.size > 0
      nil
    end
  end
end
