class Port
  # noinspection RailsI18nInspection
  class FindFreeService  # Найти и вернуть следующий свободный порт

    def initialize( port_type_arg )
      unless [:http, :tcp].include?(port_type_arg)
        raise ArgumentError.new(I18n.t('activerecord.errors.services.find_free_service.bad_argument'))
      end

      @port_type = port_type_arg
      @ports = Port.order(:number).pluck(:number)
    end

    def call
      #return Port::RANGE_OF_NUMBER[@port_type][:left_range] if @ports.size == 0
      return NginxConfig::first_port(@port_type) if @ports.size == 0

      new_port = find_empty_place

      return new_port if new_port
      raise StandardError.new(I18n.t('activerecord.errors.services.find_free_service.bring_range_of_diapason'))
    end
    
  private
    attr_accessor :port_type, :ports


    def find_empty_place # возвращает свободное место среди уже выделенных портов, или nil, если такого нет
      #empty_places = (Port::RANGE_OF_NUMBER[@port_type][:left_range]..Port::RANGE_OF_NUMBER[@port_type][:right_range]).to_a - ports
      NginxConfig::ranges(@port_type).each do |range|
        empty_places = (range[0]..range[1]).to_a - ports
        return empty_places[0] if empty_places.size > 0
      end
      nil
    end
  end
end
