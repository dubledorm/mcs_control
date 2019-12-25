require "net/http"

module AssistantSoft
  class TcpServer < BaseRetranslator

    START_PAIR_PATH = '/api/start_pair'
    STOP_PAIR_PATH = '/api/stop_pair'

    class RetranslatorNil < StandardError; end
    class NotFindConnectionParameters < StandardError; end
    class CommandPutError < StandardError; end


    def find_program
      program = Program.tcp_server_only.first
      raise StandardError, 'Program tcp_server does not find' unless program
      program
    end

    def switch_retranslator_on(retranslator)
      raise RetranslatorNil, I18n.t('activerecord.errors.exceptions.retranslator.retranslator_nil') if retranslator.nil?
      put_request(make_request_path(START_PAIR_PATH,
                                    retranslator.port_from, retranslator.port_to))
    end

    def switch_retranslator_off(retranslator)
      raise RetranslatorNil, I18n.t('activerecord.errors.exceptions.retranslator.retranslator_nil') if retranslator.nil?
      begin
      put_request(make_request_path(STOP_PAIR_PATH,
                                    retranslator.port_from, retranslator.port_to))
      rescue CommandPutError => e
        # Ловим здесь это прерывание, чтобы исключить ошибку, когда tcp_server был перезагружен и 'забыл' про включенные порты
        Rails.logger.error(e.message)
      end
    end

    private

    def get_program_host_port
      raise NotFindConnectionParameters, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_host') if ENV['RETRANSLATOR_HOST'].blank?
      raise NotFindConnectionParameters, I18n.t('activerecord.errors.exceptions.retranslator.need_env_retranslator_port') if ENV['RETRANSLATOR_PORT'].blank?

      { host: ENV['RETRANSLATOR_HOST'],
        port: ENV['RETRANSLATOR_PORT']
      }
    end

    def put_request(path)
      Rails.logger.info('Put request to retranslator.')
      connection_params = get_program_host_port
      req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'text/plain'})
      response = Net::HTTP.new(connection_params[:host], connection_params[:port]).start {|http| http.request(req) }
      Rails.logger.info("Retranslator response code = #{response.code}")
      raise CommandPutError, I18n.t('activerecord.errors.exceptions.retranslator.error_send_message',
                                  host: connection_params[:host],
                                  port: connection_params[:port],
                                  path: path,
                                  error: response.message) unless response.code == '200'
    end

    def make_request_path(command, port1, port2)
      "#{command}?port1=#{port1}&port2=#{port2}"
    end
  end
end
