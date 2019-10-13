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

      REGEXP_LISTEN = 'server\s*\{[\w\s#]*listen\s*(?<port_number>\d+);([\w.;=\/{}+^\s#]*)proxy_pass http:\/\/\w*[<program_name>|<program1_name>]\w*;\s*\}'.freeze

      def initialize(program)
        @program = program
      end

      def call
        Rails.logger.debug 'GetPortFromHttpConfService start identification_name = ' + program.identification_name
        http_tmp_file = FileTools::create_tmp_file
        Rails.logger.debug "GetPortFromHttpConfService download: host: #{NginxConfig.config[:nginx_server_host]}" +
                               " login: #{NginxConfig.config[:nginx_server_login]}" +
                               " password: #{NginxConfig.config[:nginx_server_password]}" +
                               " src_file: #{FileTools::create_full_path(NginxConfig.config[:nginx_http_config_path],
                                                                         nginx_http_file_name)}"+
                               " dest_file: #{http_tmp_file.path}"
        SshTools::scp_download_to_tmp_file(NginxConfig.config[:nginx_server_host],
                                           NginxConfig.config[:nginx_server_login],
                                           NginxConfig.config[:nginx_server_password],
                                           http_tmp_file.path,
                                           FileTools::create_full_path(NginxConfig.config[:nginx_http_config_path],
                                                                       nginx_http_file_name))
        Rails.logger.debug 'GetPortFromHttpConfService after download'
        # Прочитать файл в строку
        file_content = FileTools::read_file(http_tmp_file)
        http_tmp_file.unlink

        Rails.logger.debug 'GetPortFromHttpConfService file_content'
        regexp = Regexp.new(regexp_listen_prepare)

        Rails.logger.debug 'GetPortFromHttpConfService regexp = ' + regexp.to_s
        result = 0
        begin
          result = regexp.match(file_content)[:port_number]
          Rails.logger.debug 'GetPortFromHttpConfService result = ' + result.to_s
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

      def regexp_listen_prepare
        result = REGEXP_LISTEN.gsub('<program_name>', "#{program.identification_name.gsub('-','_')}")
        result.gsub('<program1_name>', "#{old_program_identification_name.gsub('-','_')}")
      end

      def old_program_identification_name
        "#{ program.instance.name }#{ program.additional_name.blank? ? '' : '-' + program.additional_name }-#{ program.program_type.to_s.gsub('_','-') }"
      end
    end
  end
end