class Program
  module Export
    class NginxHttpService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
      end

      def call
        result = []
        template = NginxTemplateConst::DEFAULT_SIMPLE_HTTP_TEMPLATE
        template = NginxTemplateConst::DEFAULT_HTTP_TEMPLATE if need_location_section?
        @program.ports.http.each do |port|
          # result += section_upstream(port)
          # result += section_server(port)
          result +=Program::Export::NginxTemplateConverter.new(server_name,
                                                               server_address,
                                                               port.number.to_s,
                                                               @program).
              convert(template).split("\n")
        end
        result
      end

      private

        attr_accessor :program

        # def section_upstream(port)
        #   result = []
        #   result << "upstream #{uniq_section_name} {"
        #   server_address.each do |server_address|
        #     result << "  server #{server_address}:#{port.number};"
        #   end
        #   result << '}'
        # end
        #
        # def section_server(port)
        #   result = []
        #   result << 'server {'
        #   result << "  listen #{port.number};"
        #   result << "  server_name #{server_name};"
        #   if need_location_section?
        #     result << '  location = / {'
        #     result << "  rewrite ^.+ /#{@program.decorate.http_prefix} permanent;"
        #     result << '  }'
        #   end
        #   result << "  location /#{@program.decorate.http_prefix} {"
        #   result << "  proxy_pass http://#{uniq_section_name};"
        #   result << '  }'
        #   result << '}'
        #   result
        # end
        #
        # def uniq_section_name
        #   "#{@program.identification_name.gsub('-','_')}_#{program.program_type}"
        # end

        def need_location_section?
          %w( mc op ).include?(program.program_type)
        end
    end
  end
end
