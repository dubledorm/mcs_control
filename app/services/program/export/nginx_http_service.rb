require 'nginx_config'

class Program
  module Export
    class NginxHttpService < Shared::ExportNginxBase

      def initialize(program)
        @program = program
      end

      def call
        result = []
        @program.ports.http.each do |port|
          result += section_upstream(port)
          result += section_server(port)
        end
        result
      end

      private

      attr_accessor :program

      def section_server(port)
        result = []
        result << 'server {'
        result << "  listen #{port.number};"
        result << "  server_name #{server_name};"
        result << '  location = / {'
        result << "  rewrite ^.+ /#{@program.decorate.http_prefix} permanent;"
        result << '  }'
        result << "  location /#{@program.decorate.http_prefix} {"
        result << "  proxy_pass http://#{@program.identification_name};"
        result << '  }'
        result << '}'
        result
      end
    end
  end
end
