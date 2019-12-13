class Retranslator
  class Base

    def initialize(port)
      @port = port
    end

    def active?
      raise NotImplementedError
    end

    def find_service
      raise NotImplementedError
    end

    def switch_retranslator_on
      raise NotImplementedError
    end

    def switch_retranslator_off
      raise NotImplementedError
    end

    private

    attr_accessor :port
  end
end