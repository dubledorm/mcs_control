# encoding: UTF-8
require 'file_tools'
require 'ssh_tools'
require 'nginx_config'
require 'nginx_tools'

class Instance
  module Nginx
    class ReloadService
      extend FileTools
      extend SshTools
      extend NginxTools


      def initialize(instance)
        @instance = instance
      end

      def call
        http_strs = create_body_http_file
        http_tmp_file = FileTools::create_and_fill_tmp_file(http_strs.join("\n"))

        tcp_strs = create_body_stream_file
        tcp_tmp_file = FileTools::create_and_fill_tmp_file(tcp_strs.join("\n"))

        send_files(http_tmp_file, tcp_tmp_file)

        reload_nginx

        FileTools::remove_file(http_tmp_file) unless http_tmp_file.nil?
        FileTools::remove_file(tcp_tmp_file) unless tcp_tmp_file.nil?
      end

      private
        attr_accessor :instance

      def create_body_http_file
        Instance::Export::NginxHttpService::new(@instance).call
      end

      def create_body_stream_file
        result = Instance::Export::NginxStreamService::new(@instance).call
        if result == []
          return ['#Empty, because the file is in the retranslator mode']
        end
        result
      end


      def send_files(http_tmp_file, tcp_tmp_file)
        test_print(http_tmp_file, tcp_tmp_file) if Rails.env.test?

        SshTools::scp_tmp_file(NginxConfig.config[:nginx_server_host],
                               NginxConfig.config[:nginx_server_login],
                               NginxConfig.config[:nginx_server_password],
                               FileTools::create_full_path(NginxConfig.config[:nginx_http_config_path],
                                                           nginx_http_file_name),
                               http_tmp_file.path) unless http_tmp_file.nil?

        SshTools::scp_tmp_file(NginxConfig.config[:nginx_server_host],
                               NginxConfig.config[:nginx_server_login],
                               NginxConfig.config[:nginx_server_password],
                               FileTools::create_full_path(NginxConfig.config[:nginx_tcp_config_path],
                                                           nginx_stream_file_name),
                               tcp_tmp_file.path) unless tcp_tmp_file.nil?

      end

      def reload_nginx
        SshTools::remote_exec(NginxConfig.config[:nginx_server_host],
                              NginxConfig.config[:nginx_server_login],
                              NginxConfig.config[:nginx_server_password],
                              'sudo systemctl reload nginx')
      end

      def nginx_http_file_name
        NginxTools::nginx_http_file_name(instance)
      end

      def nginx_stream_file_name
        NginxTools::nginx_stream_file_name(instance)
      end

      def test_print(http_tmp_file, tcp_tmp_file)
        unless http_tmp_file.nil?
          puts '-------- http_tmp_file --------'
          http_tmp_file.open
          http_tmp_file.rewind
          puts http_tmp_file.read
          http_tmp_file.close
        end

        unless tcp_tmp_file.nil?
          puts '-------- tcp_tmp_file --------'
          tcp_tmp_file.open
          tcp_tmp_file.rewind
          puts tcp_tmp_file.read
          tcp_tmp_file.close
        end
      end
    end
  end
end