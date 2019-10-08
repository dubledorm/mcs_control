# encoding: UTF-8
require 'file_tools'
require 'ssh_tools'
require 'nginx_config'
require 'nginx_tools'

class Program
  module Nginx
    class GetPortFromHttpConfService
      extend FileTools
      extend SshTools
      extend NginxTools

      REGEXP_LISTEN = 'server\s*\{\s*listen\s*(?<port_number>\d+);([\w.;=\/{}+^\s]*)proxy_pass http:\/\/\w*<program_name>\w*;\s*\}'.freeze

      def initialize(program)
        @program = program
      end

      def call
        http_tmp_file = FileTools::create_tmp_file
        SshTools::scp_download_to_tmp_file(NginxConfig.config[:nginx_server_host],
                                           NginxConfig.config[:nginx_server_login],
                                           NginxConfig.config[:nginx_server_password],
                                           http_tmp_file.path,
                                           FileTools::create_full_path(NginxConfig.config[:nginx_http_config_path],
                                                                       nginx_http_file_name))
        # Прочитать файл в строку
        file_content = FileTools::read_file(http_tmp_file)
        http_tmp_file.unlink
        regexp = Regexp.new(REGEXP_LISTEN.gsub('<program_name>', "#{program.instance.name}_#{program.program_type}"))
        result = 0
        begin
          result = regexp.match(file_content)[:port_number]
        rescue StandardError => e
          Rails.logger.error 'Do not finde port_number for program ' +
                                 "#{program.instance.name}_#{program.program_type}" +
                                 ' error_code ' + e.message
        end
        result
      end

      private
        attr_accessor :program

      def nginx_http_file_name
        NginxTools::nginx_http_file_name(program.instance)
      end
    end
  end
end