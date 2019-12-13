# encoding: UTF-8
require 'active_support/concern'

module RetranslatorToolBox
  extend ActiveSupport::Concern

  class_methods do
    # Есть хоть один свобоный порт?
    def has_free_port?
      Retranslator.all.passive.count > 0
    end

    # Вернуть первый свободный порт для ретраслятора
    def get_free_port
      Retranslator.all.passive.first
    end

    # Проверить, что порт уже в режиме ретрансляции
    def is_active?(port)
      Retranslator.all.active_by_replacement_port(port).count > 0
      # retranslator = Retranslator.first
      # return false unless retranslator
      # retranslator.active
    end

    # Проверить, что порт уже в режиме ретрансляции
    # Поиск по полю port_from
    def active_by_port_from?(port_from)
      Retranslator.all.active_by_port_from(port_from).count > 0
    end

    # def port_from(replacement_port = nil)
    #   Retranslator.all.active_by_replacement_port(replacement_port).first&.port_from
    #   # retranslator = Retranslator.first
    #   # return nil unless retranslator
    #   # retranslator.port_from
    # end

    # Найти replacement_port по полю port_from
    def replacement_port(port_from = nil)
      Retranslator.all.active_by_port_from(port_from).first&.replacement_port
      # retranslator = Retranslator.first
      # return nil unless retranslator
      # return nil unless retranslator.active?
      # retranslator.replacement_port
    end
  end
end
