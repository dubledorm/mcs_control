require 'nginx_config'

module Shared
  class ExportNginxBase
    protected
      def section_upstream(port)
        raise NotImplementedError
      end

      def section_server(port)
        raise NotImplementedError
      end

    private
      attr_accessor :program

      def server_address
        NginxConfig.config[:server_address]
      end

      # def retranslator_port_from(replacement_port)
      #   Retranslator.port_from(replacement_port.number)
      # end

      def retranslator_active_by_from?(port_from)
        Retranslator.active_by_port_from?(port_from.number)
      end

      def retranslator_active?(port)
        Retranslator.is_active?(port.number)
      end

      def retranslator_replacement_port(port_to)
        Retranslator.replacement_port(port_to.number)
      end


      def server_name
        NginxConfig.config[:server_name]
      end
  end
end