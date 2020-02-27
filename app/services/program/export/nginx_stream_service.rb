class Program
  module Export
    class NginxStreamService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
      end

      def call
        Rails.logger.debug "NginxStreamService call"
        result = []

        template = select_template

        @program.ports.tcp.each do |port|
          next unless port_in_range?(port)
          Rails.logger.debug "NginxStreamService call port = #{port.number}"

          # Пропускаем если это ретранслируемый порт. Эта проверка действует для ретранслируемого порта
          next if retranslator_active?(port)
          Rails.logger.debug "NginxStreamService call before section create"

          # Следующая проверка для программы ретранслатора. Если для её порта (port_to) есть активный ретранслятор
          # то заменить входной порт, на номер ретранслируемого порта
          if retranslator_active_by_from?(port)
            listen_port_number = retranslator_replacement_port(port).to_i
          else
            listen_port_number = port.number.to_s
          end
          result += Program::Export::NginxTemplateConverter.new(server_name,
                                                                server_address,
                                                                port.number.to_s,
                                                                listen_port_number.to_s,
                                                                @program).convert(template).split("\n")
        end
        result
      end

      private

        def port_in_range?(port)
          #Port::RANGE_OF_NUMBER[:tcp][:left_range] <= port.number && Port::RANGE_OF_NUMBER[:tcp][:right_range] >= port.number
          NginxConfig.config[:stream_ports_range].any?{ |range| range[0] <= port.number && range[1] >= port.number}
        end

        def select_template
          template = NginxTemplate.get_by_tcp_and_program_type(@program)
          template = NginxTemplateConst::DEFAULT_TCP_TEMPLATE if template.blank?
          template
        end
    end
  end
end
