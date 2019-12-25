require 'rails_helper'

module TcpServerSupport
  def tcp_server_start
    ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    start_tcp_server = "docker run --rm --name tcp_server --publish 3008:3000 --publish 31022:31022 --publish 31023:31023 --env REDIS_CLOUD_URL='redis://#{ip.ip_address}:6379' registry.infsphr.info/tcp_server:v1.1.0 &"
    puts start_tcp_server
    result = system(start_tcp_server)

    raise 'Not started tcp_server' if result.nil? || result == false
    sleep(15)
  end

  def tcp_server_stop
    start_tcp_server = 'docker stop tcp_server'
    system(start_tcp_server)
  end
end