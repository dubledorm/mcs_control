module HealthCheck
  class CheckOneServerService

    HEALTH_CHECK_PATH = '/mc/api/v1/health_check'
    AUTORITHATION_DATA = 'Basic aGVhbHRoX2NoZWNrOk1vbml0b3JpbmdAMjAxOQ=='

    class CommandPostError < StandardError; end

    def initialize(program)
      @program = program
    end

    def call
      Rails.logger.debug "HealthCheck::CheckOneServerService"
      response = post_request(HEALTH_CHECK_PATH)

      ap(response)
    end

    private
    attr_accessor :program

    def get_program_host_port
      { host: 'http://infsphr.info',
        port: '30002'
      }
    end

    def post_request(path)
      Rails.logger.info('Post request to mc.')
      connection_params = get_program_host_port
      req = Net::HTTP::Put.new(path, initheader = { 'Content-Type' => 'application/json', 'Autorisation' => AUTORITHATION_DATA })
      response = Net::HTTP.new(connection_params[:host], connection_params[:port]).start {|http| http.request(req) }
      Rails.logger.info("HealthCheck response code = #{response.code}")
      raise CommandPostError, I18n.t('activerecord.errors.exceptions.retranslator.error_send_message',
                                    host: connection_params[:host],
                                    port: connection_params[:port],
                                    path: path,
                                    error: response.message) unless response.code == '200'
      response
    end

  end
end