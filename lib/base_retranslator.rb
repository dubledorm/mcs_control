class BaseRetranslator
  def find_program
    raise NotImplementedError
  end

  def self.switch_retranslator_on(retranslator)

  end

  def self.switch_retranslator_off(retranslator)

  end
end
