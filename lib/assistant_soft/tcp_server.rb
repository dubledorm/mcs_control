require "net/http"

module AssistantSoft
  class TcpServer < BaseRetranslator

    START_PAIR_PATH = '/api/start_pair'
    STOP_PAIR_PATH = '/api/stop_pair'

    def initialize
      connection_params = get_program_host_port
      @host = connection_params[:host]
      @port = connection_params[:port]
    end

    def find_program
      program = Program.tcp_server_only.first
      raise StandardError, 'Program tcp_server does not find' unless program
      program
    end

    def switch_retranslator_on(retranslator)
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.do_not_find_retranslator',
                                  port: port.number) if retranslator.nil?
      put_request(make_request_path(START_PAIR_PATH,
                                    retranslator.port_from, retranslator.port_to))
    end

    def switch_retranslator_off(retranslator)
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.do_not_find_retranslator',
                                  port: port.number) if retranslator.nil?
      put_request(make_request_path(STOP_PAIR_PATH,
                                    retranslator.port_from, retranslator.port_to))
    end

    private

    attr_accessor :port, :host

    def get_program_host_port
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_host') if ENV['RETRANSLATOR_HOST'].blank?
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_port') if ENV['RETRANSLATOR_PORT'].blank?

      { host: ENV['RETRANSLATOR_HOST'],
        port: ENV['RETRANSLATOR_PORT']
      }
    end

    def put_request(path)
      Rails.logger.info('Put request to retranslator.')
      req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'text/plain'})
      response = Net::HTTP.new(host, port).start {|http| http.request(req) }
      Rails.logger.info("Retranslator response code = #{response.code}")
      raise StandardError, I18n.t('activerecord.errors.exceptions.retranslator.error_send_message',
                                  host: host,
                                  port: port,
                                  path: path,
                                  error: response.message) unless response.code == '200'
    end

    def make_request_path(command, port1, port2)
      "#{command}?port1=#{port1}&port2=#{port2}"
    end
  end
end
