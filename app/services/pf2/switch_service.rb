require 'database_tools'

module Pf2
  class SwitchService
    include DatabaseTools

    def initialize(port, mode)
      @port = port
      @mode = mode
    end

    def call
      # записать в таблицу
      if mode
        raise 'Retranslator already switched on' if Retranslator.first&.active
        set_active_and_port
      else
        set_active_off
      end

      # Переписать pf2
      pf2 = Program.pf2_only.first
      raise StandardError, 'Program Pf2 does n@ot finded' unless pf2
      Instance::Nginx::ReloadService::new(pf2.instance).call

      # Переписать Instanse порта
      program = port.program
      Instance::Nginx::ReloadService::new(program.instance).call
    end

    private
      attr_accessor :port, :mode

      def set_active_and_port
        retranslator = Retranslator.first
        retranslator.active = true
        retranslator.replacement_port = port.number
        retranslator.save
      end

      def set_active_off
        retranslator = Retranslator.first
        retranslator.active = false
        retranslator.save
      end
  end
end