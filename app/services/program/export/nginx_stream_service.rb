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
          result << "upstream #{uniq_section_name(port)} {"
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
          result << "  proxy_pass #{uniq_section_name(port)};"
          result << '}'
        end

        def uniq_section_name(port)
          "#{@program.identification_name.gsub('-','_')}_#{port.number}"
        end
    end
  end
end
