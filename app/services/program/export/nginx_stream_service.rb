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

        template = NginxTemplate.get_by_tcp_and_program_type(@program)
        template = NginxTemplateConst::DEFAULT_TCP_TEMPLATE if template.blank?

        @program.ports.tcp.each do |port|
          next unless port_in_range?(port)
          Rails.logger.debug "NginxStreamService call port = #{port}"

          next if @retranslator_active && retranslator_replacement_port.to_i == port.number
          Rails.logger.debug "NginxStreamService call before section create"

          if @retranslator_active && @retranslator_port == port.number
            port_number = retranslator_replacement_port.to_i
          else
            port_number = port.number.to_s
          end
          result += Program::Export::NginxTemplateConverter.new(server_name,
                                                                server_address,
                                                                port_number.to_s,
                                                                @program).convert(template).split("\n")
        end
        result
      end

      private

        def port_in_range?(port)
          Port::RANGE_OF_NUMBER[:tcp][:left_range] <= port.number && Port::RANGE_OF_NUMBER[:tcp][:right_range] >= port.number
        end
    end
  end
end
