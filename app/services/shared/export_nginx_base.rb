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

      def retranslator_port
        NginxConfig.config[:retranslator_port]
      end

      def server_name
        NginxConfig.config[:server_name]
      end
  end
end