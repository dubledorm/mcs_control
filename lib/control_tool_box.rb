module ControlToolBox

  KNOWN_RETRANSLATOR_TYPES = { pf2: AssistantSoft::Pf2.new,
                               tcp_server: nil
  }

  def program_type
    raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_program',
                               values: KNOWN_RETRANSLATOR_TYPES.keys) if ENV['RETRANSLATOR_PROGRAM'].blank?
    ENV['RETRANSLATOR_PROGRAM'].parameterize.underscore.to_sym
  end

  def retranslator_class
    KNOWN_RETRANSLATOR_TYPES[program_type]
  end
end
