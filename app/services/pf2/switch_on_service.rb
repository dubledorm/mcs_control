require 'database_tools'

module Pf2
  class SwitchOnService
    include DatabaseTools

    def initialize(port)
      @port = port
    end

    def call
      # записать в таблицу
      set_active_and_port

      # Переписать pf2

      # Переписать Instanse порта
    end

    private
      attr_accessor :port

      def set_active_and_port
        retranslator = Retranslator.first
        retranslator.active = true
        retranslator.replacement_port = port.number
        retranslator.save
      end
  end
end