require 'nginx_config'

class Program
  module Export
    class NginxStreamService

      def initialize(program, retranslator = false)
        @program = program
        @retranslator = retranslator
      end

      def call
        result = []
        @program.ports.tcp.each do |port|
          next if @retranslator && retranslator_port.to_i == port.number
          result += section_upstream(port)
          result += section_server(port)
        end
        result
      end

      private
        def server_address
          NginxConfig.config[:server_address]
        end

        def retranslator_port
          NginxConfig.config[:retranslator_port]
        end

        def section_upstream(port)
          result = []
          result << "upstream #{@program.identification_name}_#{port.number} {"
          server_address.each do |server_addres|
            result << "  server #{server_addres}:#{port.number};"
          end
          result << '}'
        end

        def section_server(port)
          result = []
          result << 'server {'
          result << "  listen #{port.number};"
          result << "  proxy_pass #{@program.identification_name}_#{port.number};"
          result << '}'
        end
    end
  end
end
