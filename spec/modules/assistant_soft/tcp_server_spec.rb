require 'rails_helper'
require 'socket'
require 'support/tcp_server_support'

describe AssistantSoft::TcpServer do

  it { expect{ described_class.new }.to_not raise_exception}

  context 'when nothing program exists' do
    it { expect{ described_class.new.find_program }.to raise_exception(StandardError)}
  end

  context 'when tcp_server program does not exist' do
    let!(:mc_program) {FactoryGirl.create :mc_program}
    let!(:dev_program) {FactoryGirl.create :dev_program}

    it { expect{ described_class.new.find_program }.to raise_exception(StandardError)}
  end

  context 'when tcp_server program exists' do
    let!(:mc_program) {FactoryGirl.create :mc_program}
    let!(:tcp_server_program) {FactoryGirl.create :tcp_server_program}
    let!(:dev_program) {FactoryGirl.create :dev_program}

    it { expect(described_class.new.find_program).to eq(tcp_server_program) }
  end

  context 'when enviroment variable does not exist' do
    let!(:retranslator) {FactoryGirl.create :retranslator}

    it { expect{ described_class.new.switch_retranslator_on(retranslator) }.to raise_exception(AssistantSoft::TcpServer::NotFindConnectionParameters)}
    it { expect{ described_class.new.switch_retranslator_off(retranslator) }.to raise_exception(AssistantSoft::TcpServer::NotFindConnectionParameters)}

    it 'test print' do
      begin
        described_class.new.switch_retranslator_on(retranslator)
      rescue AssistantSoft::TcpServer::NotFindConnectionParameters => e
        puts 'Отладочная печать:'
        puts e.message
      end
    end

    it { expect{ described_class.new.switch_retranslator_on(nil) }.to raise_exception(AssistantSoft::TcpServer::RetranslatorNil)}
    it { expect{ described_class.new.switch_retranslator_off(nil) }.to raise_exception(AssistantSoft::TcpServer::RetranslatorNil)}

    it 'test print' do
      begin
        described_class.new.switch_retranslator_on(nil)
      rescue AssistantSoft::TcpServer::RetranslatorNil => e
        puts 'Отладочная печать:'
        puts e.message
      end
    end
  end

  context 'when enviroment variable exists' do
    let!(:retranslator) {FactoryGirl.create :retranslator}

    before :each do
      ENV['RETRANSLATOR_HOST'] = '127.0.0.1'
      ENV['RETRANSLATOR_PORT'] = '3008'
    end

    it { expect{ described_class.new.switch_retranslator_on(nil) }.to raise_exception(AssistantSoft::TcpServer::RetranslatorNil)}
    it { expect{ described_class.new.switch_retranslator_off(nil) }.to raise_exception(AssistantSoft::TcpServer::RetranslatorNil)}

    it { expect{ described_class.new.switch_retranslator_on(retranslator) }.to raise_exception(Errno::ECONNREFUSED)}
    it { expect{ described_class.new.switch_retranslator_off(retranslator) }.to raise_exception(Errno::ECONNREFUSED)}

    context 'when tcp_server started' do
      include TcpServerSupport

      let!(:retranslator) {FactoryGirl.create :retranslator, port_from: 31022, port_to: 31023}
      let!(:retranslator1) {FactoryGirl.create :retranslator, port_from: 31024, port_to: 31025}


      before :all do
        tcp_server_start
      end

      after :all do
        tcp_server_stop
      end

      it { expect{ described_class.new.switch_retranslator_on(retranslator) }.to_not raise_error }
      it { expect{ described_class.new.switch_retranslator_off(retranslator) }.to_not raise_error }

      it { expect{ described_class.new.switch_retranslator_off(retranslator1) }.to_not raise_error }
    end
  end
end