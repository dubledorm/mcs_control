require 'net/http'
require 'json'

module HealthCheck
  class CheckOneServerService

    HEALTH_CHECK_PATH = '/mc/api/v1/health_check'
    HOST_NAME = 'infsphr.info'
    AUTORITHATION_PASSWORD = 'health_check'
    AUTORITHATION_LOGIN = 'Monitoring@2019'
    NUMBER_OF_HOURS = 24

    class CommandPostError < StandardError; end
    class ProgramTypeError < StandardError; end

    def initialize(program, hc_logger)
      @program = program
      @hc_logger = hc_logger
      Raise ProgramTypeError, I18n.t('activerecord.errors.exceptions.health_check.program_type_error') unless program.program_type == 'mc'
    end

    def call
      Rails.logger.debug "HealthCheck::CheckOneServerService"
      begin
        response = post_request(HEALTH_CHECK_PATH)

        number_of_null_ti = JSON.parse(response.body, symbolize_names: true)[:number_of_null_ti]
        hc_logger.info("#{program.identification_name} number_of_null_ti: #{number_of_null_ti}")
      rescue CommandPostError => e
        hc_logger.error("#{program.identification_name} #{e.message}")
      end
    end

    private
    attr_accessor :program, :hc_logger


    def get_program_host_port
      { host: HOST_NAME,
        port: program.ports.http.first&.number
      }
    end

    def post_request(path)
      Rails.logger.info('HealthCheck request to mc.')
      connection_params = get_program_host_port

      http = Net::HTTP.new(connection_params[:host], connection_params[:port])
      request = Net::HTTP::Post.new(HEALTH_CHECK_PATH)

      request.basic_auth(AUTORITHATION_PASSWORD, AUTORITHATION_LOGIN)
      request.body = {number_of_hours: NUMBER_OF_HOURS}.to_json
      request["Content-Type"] = "application/json"

      response = http.request(request)
      Rails.logger.info("HealthCheck response code = #{response.code}")
      raise CommandPostError, I18n.t('activerecord.errors.exceptions.health_check.post_error',
                                                                     host: connection_params[:host],
                                                                     port: connection_params[:port],
                                                                     path: path,
                                                                     error: "#{response.code} - #{response.message}") unless response.code == '200'
      response
    end

  end
end