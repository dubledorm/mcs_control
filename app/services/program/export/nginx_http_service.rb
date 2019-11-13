class Program
  module Export
    class NginxHttpService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
      end

      def call
        result = []
        template = NginxTemplate.get_by_http_and_program_type(@program)
        if template.blank?
          template = NginxTemplateConst::DEFAULT_SIMPLE_HTTP_TEMPLATE
          template = NginxTemplateConst::DEFAULT_HTTP_TEMPLATE if need_location_section?
        end

        @program.ports.http.each do |port|
          result += Program::Export::NginxTemplateConverter.new(server_name,
                                                                server_address,
                                                                port.number.to_s,
                                                                port.number.to_s,
                                                                @program).convert(template).split("\n")
        end
        result
      end

      private

        attr_accessor :program

        def need_location_section?
          %w( mc op ).include?(program.program_type)
        end
    end
  end
end
