class Program
  module Export
    class NginxStreamService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
        @retranslator_active = retranslator_active?
        @retranslator_port = retranslator_port.to_i
        Rails.logger.debug "NginxStreamService retranslator_active = #{@retranslator_active} retranslator_port = #{@retranslator_port}"+
            " retranslator_replacement_port = #{retranslator_replacement_port}"
      end

      def call
        Rails.logger.debug "NginxStreamService call"
        result = []
        template = NginxTemplateConst::DEFAULT_TCP_TEMPLATE

        @program.ports.tcp.each do |port|
          next unless port_in_range?(port)
          Rails.logger.debug "NginxStreamService call port = #{port}"

          next if @retranslator_active && retranslator_replacement_port.to_i == port.number
          Rails.logger.debug "NginxStreamService call before section create"

          # result += section_upstream(port)
          # result += section_server(port)
          if @retranslator_active && @retranslator_port == port.number
            port_number = retranslator_replacement_port.to_i
          else
            port_number = port.number.to_s
          end
          result +=Program::Export::NginxTemplateConverter.new(server_name,
                                                               server_address,
                                                               port_number.to_s,
                                                               @program).
              convert(template).split("\n")
        end
        result
      end

      private

        # def section_upstream(port)
        #   result = []
        #   result << "upstream #{uniq_section_name(port)} {"
        #   server_address.each do |server_address|
        #     result << "  server #{server_address}:#{port.number};"
        #   end
        #   result << '}'
        # end
        #
        # def section_server(port)
        #   Rails.logger.debug "NginxStreamService section_server port.number = #{port.number}"
        #   result = []
        #   result << 'server {'
        #   if @retranslator_active && @retranslator_port == port.number
        #     Rails.logger.debug "NginxStreamService retranslator_replacement_port = #{retranslator_replacement_port.to_i}"
        #     result << "  listen #{retranslator_replacement_port.to_i};"
        #   else
        #     result << "  listen #{port.number};"
        #   end
        #   result << "  proxy_pass #{uniq_section_name(port)};"
        #   result << '}'
        # end
        #
        # def uniq_section_name(port)
        #   "#{@program.identification_name.gsub('-','_')}_#{port.number}"
        # end

        def port_in_range?(port)
          Port::RANGE_OF_NUMBER[:tcp][:left_range] <= port.number && Port::RANGE_OF_NUMBER[:tcp][:right_range] >= port.number
        end
    end
  end
end
