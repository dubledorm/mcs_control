class Program
  module Export
    class NginxStreamService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
        @retranslator_active = retranslator_active?
      end

      def call
        result = []
        @program.ports.tcp.each do |port|
          next if @retranslator_active && retranslator_replacement_port.to_i == port.number
          result += section_upstream(port)
          result += section_server(port)
        end
        result
      end

      private

        def section_upstream(port)
          result = []
          result << "upstream #{@program.identification_name}_#{port.number} {"
          server_address.each do |server_address|
            result << "  server #{server_address}:#{port.number};"
          end
          result << '}'
        end

        def section_server(port)
          result = []
          result << 'server {'
          if @retranslator_active && retranslator_port.to_i == port.number
            result << "  listen #{retranslator_replacement_port.to_i};"
          else
            result << "  listen #{port.number};"
          end
          result << "  proxy_pass #{@program.identification_name}_#{port.number};"
          result << '}'
        end
    end
  end
end
