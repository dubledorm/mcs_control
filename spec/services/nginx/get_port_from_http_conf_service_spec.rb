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


  FILE_OLD_CONTENT = 'server {

    # management company block

    listen 30003;

    server_name infsphr.info;



    # permanent redirect / to /mc

    location = / {

        rewrite ^.+ /mc permanent;

    }



    location /mc {

        proxy_pass http://inf_chicken_gallery_mc_backend;

    }

}





server {

    # management company block

    listen 30004;

    server_name infsphr.info;



    # permanent redirect / to /mc

    location = / {

        rewrite ^.+ /mc permanent;

    }



    location /mc {

        proxy_pass http://inf_chicken_klen_mc_backend;

    }

}





server {

    # management company block

    listen 30005;

    server_name infsphr.info;



    # permanent redirect / to /mc

    location = / {

        rewrite ^.+ /mc permanent;

    }



    location /mc {

        proxy_pass http://inf_chicken_scec_mc_backend;
    }
}'.freeze


  context 'when config file has new format' do

    before :all do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      File.open(dest_file_name, 'w') { |file|
        file.write(FILE_CONTENT)
      }
    end

    after :all do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      File.delete(dest_file_name)
    end

    context 'when instance has mc program' do
      it { expect{ described_class.new(program_mc).call }.to_not raise_exception }
      it { expect(described_class.new(program_mc).call).to eq('462') }
    end

    context 'when src directory does not exists' do
      before :each do
        bad_config = NginxConfig.config.clone
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
        bad_config = NginxConfig.config.clone
        bad_config[:nginx_server_host] = 'ewrterwtwert'
        allow(NginxConfig).to receive(:config).
            and_return( bad_config )
      end

      it {
        expect{ described_class.new(program_mc).call }.to raise_exception(SocketError)
      }
    end
  end


  context 'when config file has old format' do
    let!(:program_gallery_mc) {FactoryGirl.create :program, instance: instance, program_type: 'mc',
                                          database_name: 'mc_testmilandrchicken_gallery',
                                          identification_name: 'testmilandrchicken-mc-gallery', additional_name: 'gallery',
                                                  db_status: 'undefined'}


    before :all do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      File.open(dest_file_name, 'w') { |file|
        file.write(FILE_OLD_CONTENT)
      }
    end

    after :all do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      File.delete(dest_file_name)
    end

    context 'when instance has mc program' do
      it { expect{ described_class.new(program_gallery_mc).call }.to_not raise_exception }
      it { expect(described_class.new(program_gallery_mc).call).to eq('30003') }
    end
  end
end