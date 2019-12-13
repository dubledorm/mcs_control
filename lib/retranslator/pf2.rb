class Retranslator
  class Pf2::Retranslator::Base
    def active?
      Retranslator.active?(port)
    end

    def find_service
      pf2 = Program.pf2_only.first
      raise StandardError, 'Program Pf2 does not finded' unless pf2
    end

    def switch_retranslator_on
      raise NotImplementedError
    end

    def switch_retranslator_off
      raise NotImplementedError
    end
  end
end