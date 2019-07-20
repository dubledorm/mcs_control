class Port
  class Factory
    def self.build(port)
      begin
        port.number = Port::FindFreeService.new(:tcp).call
        port.port_type = 'tcp'
        port.db_status = 'undefined'
        port.save!
        return port
      rescue StandardError => e
        raise e
      end
    end
  end
end