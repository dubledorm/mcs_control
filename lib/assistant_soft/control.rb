
module AssistantSoft
  class Control
    KNOWN_RETRANSLATOR_TYPES = { pf2: AssistantSoft::Pf2.new,
                                 tcp_server: AssistantSoft::TcpServer.new
    }


    def self.find_retranslator_program
      retranslator_class.find_program
    end

    def self.switch_retranslator_on(retranslator)
      retranslator_class.switch_retranslator_on(retranslator)
    end

    def self.switch_retranslator_off(retranslator)
      retranslator_class.switch_retranslator_off(retranslator)
    end

    private

    def self.program_type
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_program',
                                  values: KNOWN_RETRANSLATOR_TYPES.keys) if ENV['RETRANSLATOR_PROGRAM'].blank?
      ENV['RETRANSLATOR_PROGRAM'].parameterize.underscore.to_sym
    end

    def self.retranslator_class
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.wrong_env_retranslator_program',
                                  values: KNOWN_RETRANSLATOR_TYPES.keys,
                                  value: program_type) if KNOWN_RETRANSLATOR_TYPES[program_type].blank?
      KNOWN_RETRANSLATOR_TYPES[program_type]
    end
  end
end