require 'rails_helper'

# Для работы данного теста необходимо настроить секцию test в файле config/nginx_config.yml
# Достаточно настроить передачу сам на себя.
# Dest директории должны существовать

RSpec.describe Instance::Nginx::ReloadService do

  context 'when instance does not have any program' do
    let!(:instance) { FactoryGirl::create :instance }

    it {
      expect{ described_class.new(instance).call }.to_not raise_exception
    }
  end

  context 'when instance has all program' do
    let!(:instance) { FactoryGirl::create :full_instance }

    it {
      expect{ described_class.new(instance).call }.to_not raise_exception
    }
  end

  context 'when destination directory does not exists' do
    let!(:instance) { FactoryGirl::create :full_instance }
    before :each do
      bad_config = NginxConfig.config
      bad_config[:nginx_tcp_config_path] = ''
      bad_config[:nginx_http_config_path] = ''
      allow(NginxConfig).to receive(:config).
          and_return( bad_config )
    end

    it {
      expect{ described_class.new(instance).call }.to raise_exception(Net::SCP::Error)
    }
  end

  context 'when destination host does not exists' do
    let!(:instance) { FactoryGirl::create :full_instance }
    before :each do
      bad_config = NginxConfig.config
      bad_config[:nginx_server_host] = 'ewrterwtwert'
      allow(NginxConfig).to receive(:config).
          and_return( bad_config )
    end

    it {
      expect{ described_class.new(instance).call }.to raise_exception(SocketError)
    }
  end
end