module DatabaseControl
  class Base
    def prepare
      raise NotImplementedError
    end

    def call
      raise NotImplementedError
    end
  end
end
