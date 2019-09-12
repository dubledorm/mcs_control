module Shared
  class ExportNginxBase
    protected
      def section_upstream(port)
        result = []
        result << "upstream #{@program.identification_name}_#{port.number} {"
        server_address.each do |server_addres|
          result << "  server #{server_addres}:#{port.number};"
        end
        result << '}'
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