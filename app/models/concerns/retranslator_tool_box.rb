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

    def find_by_replacement_port(replacement_port)
      Retranslator.all.by_replacement_port(replacement_port).first
    end

    # Проверить, что порт уже в режиме ретрансляции
    def is_active?(port)
      Retranslator.all.active_by_replacement_port(port).count > 0
     end

    # Проверить, что порт уже в режиме ретрансляции
    # Поиск по полю port_from
    def active_by_port_from?(port_from)
      Retranslator.all.active_by_port_from(port_from).count > 0
    end

    # Найти replacement_port по полю port_from
    def replacement_port(port_from)
      Retranslator.all.active_by_port_from(port_from).first&.replacement_port
    end

    # Найти port_to по replacement_port
    def port_to(replacement_port)
      Retranslator.all.active_by_replacement_port(replacement_port).first&.port_to
    end

    def user(replacement_port)
      Retranslator.all.active_by_replacement_port(replacement_port).first&.admin_user&.email
    end

    def channel_name_port_from(channel_name)
      channel_name.split('_')[0].to_i
    end

    def channel_name_port_to(channel_name)
      channel_name.split('_')[1].to_i
    end

    def channel_names
      Retranslator.all.map{ |retranslator| "#{retranslator.port_from}_#{retranslator.port_to}" }
    end
  end

  def channel_name
    "#{port_from}_#{port_to}"
  end
end
