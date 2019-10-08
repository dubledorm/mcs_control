require 'rails_helper'

# Для работы данного теста необходимо настроить секцию test в файле config/nginx_config.yml

RSpec.describe Program::Nginx::GetPortFromHttpConfService do
  let!(:instance) { FactoryGirl::create :instance, name: 'testmilandrchicken' }
  let!(:program_mc) {FactoryGirl.create :program, instance: instance, program_type: 'mc',
                                        database_name: 'mc_testmilandrchicken',
                                        identification_name: 'testmilandrchicken-mc', db_status: 'undefined'}


  FILE_CONTENT = 'upstream identification_testmilandrchicken_mc_backend {
  server 192.168.100.11:462;
  server 192.168.100.12:462;
  server 192.168.100.14:462;
  server 192.168.100.24:462;
}
server {
  listen 462;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_testmilandrchicken_mc_backend;
  }
}'.freeze

  before :all do
    dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
    file = File.open(dest_file_name, 'w')
    file.write(FILE_CONTENT)
    file.close
  end

  context 'when instance has mc program' do
    it { expect{ described_class.new(program_mc).call }.to_not raise_exception }
    it { expect(described_class.new(program_mc).call).to eq('462') }
  end

  context 'when src directory does not exists' do
    before :each do
      bad_config = NginxConfig.config
      bad_config[:nginx_tcp_config_path] = ''
      bad_config[:nginx_http_config_path] = ''
      allow(NginxConfig).to receive(:config).
          and_return( bad_config )
    end

    it {
      expect{ described_class.new(program_mc).call }.to raise_exception(Net::SCP::Error)
    }
  end

  context 'when src host does not exists' do
    before :each do
      bad_config = NginxConfig.config
      bad_config[:nginx_server_host] = 'ewrterwtwert'
      allow(NginxConfig).to receive(:config).
          and_return( bad_config )
    end

    it {
      expect{ described_class.new(program_mc).call }.to raise_exception(SocketError)
    }
  end
end