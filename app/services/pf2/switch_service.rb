require 'database_tools'

module Pf2
  class SwitchService
    include DatabaseTools

    def initialize(port, mode, user = nil)
      @port = port
      @mode = mode
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        # записать в таблицу
        retranslator = write_to_retranslator_table

        # Переписать конфиг nginx
        reload_nginx

        # Отправить команду в программу ретранслятора принять новую конфигурацию
        send_command_to_retranslator(retranslator)
      end
    end

    private
      attr_accessor :port, :mode, :user

      def set_active_and_port
        retranslator = Retranslator.get_free_port
        raise StandardError, 'Do not find free retranslator port' if retranslator.nil?
        retranslator.active = true
        retranslator.replacement_port = port.number
        retranslator.admin_user = user
        retranslator.save
        retranslator
      end

      def set_active_off
        retranslator = Retranslator.all.active_by_replacement_port(port.number).first
        raise StandardError, 'Do not find record in Retranslator for port ' + port.number.to_s if retranslator.nil?
        retranslator.active = false
        retranslator.replacement_port = nil
        retranslator.admin_user = nil
        retranslator.save
        retranslator
      end

      def write_to_retranslator_table
        if mode
          raise 'Retranslator already switched on' if Retranslator.is_active?(@port)
          return set_active_and_port
        end

        set_active_off
      end

      def reload_nginx
        # Переписать nginx для ретранслятор
        program_retranslator = find_retranslator_program
        Instance::Nginx::ReloadService::new(program_retranslator.instance).call

        # Переписать nginx для Instanse порта
        program = port.program
        Instance::Nginx::ReloadService::new(program.instance).call
      end

      def send_command_to_retranslator(retranslator)
        if mode
          AssistantSoft::Control::switch_retranslator_on(retranslator)
        else
          AssistantSoft::Control::switch_retranslator_off(retranslator)
        end
      end

      def find_retranslator_program
        AssistantSoft::Control::find_retranslator_program
      end
  end
end