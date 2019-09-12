require 'rails_helper'
require 'support/feature_helper'
require 'database_tools'
require 'nginx_config'

SERVER_ADDRESS = %w(192.168.100.11 192.168.100.12 192.168.100.14 192.168.100.24).freeze

RSpec.describe Program::Export::NginxStreamService do
  context 'when switch off retranslator' do
    context 'when program has a port but no tcp type' do
      let!(:program) { FactoryGirl::create :mc_program }

      it {
        expect(described_class.new(program).call).to eq([])
      }
    end

    context 'when program has 3 ports of tcp type' do
      let!(:program) { FactoryGirl::create :dev_program }

      it {
        expect(described_class.new(program).call).to eq([ "upstream #{program.identification_name}_#{program.ports[0].number} {",
                                                          "  server #{SERVER_ADDRESS[0]}:#{program.ports[0].number};",
                                                          "  server #{SERVER_ADDRESS[1]}:#{program.ports[0].number};",
                                                          "  server #{SERVER_ADDRESS[2]}:#{program.ports[0].number};",
                                                          "  server #{SERVER_ADDRESS[3]}:#{program.ports[0].number};",
                                                          '}',
                                                          'server {',
                                                          "  listen #{program.ports[0].number};",
                                                          "  proxy_pass #{program.identification_name}_#{program.ports[0].number};",
                                                          '}',
                                                          "upstream #{program.identification_name}_#{program.ports[1].number} {",
                                                          "  server #{SERVER_ADDRESS[0]}:#{program.ports[1].number};",
                                                          "  server #{SERVER_ADDRESS[1]}:#{program.ports[1].number};",
                                                          "  server #{SERVER_ADDRESS[2]}:#{program.ports[1].number};",
                                                          "  server #{SERVER_ADDRESS[3]}:#{program.ports[1].number};",
                                                          '}',
                                                          'server {',
                                                          "  listen #{program.ports[1].number};",
                                                          "  proxy_pass #{program.identification_name}_#{program.ports[1].number};",
                                                          '}',
                                                          "upstream #{program.identification_name}_#{program.ports[2].number} {",
                                                          "  server #{SERVER_ADDRESS[0]}:#{program.ports[2].number};",
                                                          "  server #{SERVER_ADDRESS[1]}:#{program.ports[2].number};",
                                                          "  server #{SERVER_ADDRESS[2]}:#{program.ports[2].number};",
                                                          "  server #{SERVER_ADDRESS[3]}:#{program.ports[2].number};",
                                                          '}',
                                                          'server {',
                                                          "  listen #{program.ports[2].number};",
                                                          "  proxy_pass #{program.identification_name}_#{program.ports[2].number};",
                                                          '}'
                                                        ])
      }
    end

  end

  context 'when retranslator switch on' do
    context 'when retranslator switch on but program does not have tcp port' do
      let!(:program) { FactoryGirl::create :mc_program }

      it {
        expect(described_class.new(program, true).call).to eq([])
      }
    end

    context 'when retranslator switch on and program have tcp port' do
      let!(:program) { FactoryGirl::create :dev_program }

      before :each do
        allow(NginxConfig).to receive(:config).
            and_return( { server_address: SERVER_ADDRESS, retranslator_port: program.ports[1].number.to_s } )
      end


      it {
        expect(described_class.new(program, true).call).to eq([ "upstream #{program.identification_name}_#{program.ports[0].number} {",
                                                                "  server #{SERVER_ADDRESS[0]}:#{program.ports[0].number};",
                                                                "  server #{SERVER_ADDRESS[1]}:#{program.ports[0].number};",
                                                                "  server #{SERVER_ADDRESS[2]}:#{program.ports[0].number};",
                                                                "  server #{SERVER_ADDRESS[3]}:#{program.ports[0].number};",
                                                                '}',
                                                                'server {',
                                                                "  listen #{program.ports[0].number};",
                                                                "  proxy_pass #{program.identification_name}_#{program.ports[0].number};",
                                                                '}',
                                                                "upstream #{program.identification_name}_#{program.ports[2].number} {",
                                                                "  server #{SERVER_ADDRESS[0]}:#{program.ports[2].number};",
                                                                "  server #{SERVER_ADDRESS[1]}:#{program.ports[2].number};",
                                                                "  server #{SERVER_ADDRESS[2]}:#{program.ports[2].number};",
                                                                "  server #{SERVER_ADDRESS[3]}:#{program.ports[2].number};",
                                                                '}',
                                                                'server {',
                                                                "  listen #{program.ports[2].number};",
                                                                "  proxy_pass #{program.identification_name}_#{program.ports[2].number};",
                                                                '}'
                                                              ])
      }
    end
  end
end


RSpec.describe Instance::Export::NginxStreamService do

  context 'when instance has one program' do
    let!(:program) { FactoryGirl::create :dev_program_and_one_port }

    it {
      expect(described_class.new(program.instance).call).to eq([ "upstream #{program.identification_name}_#{program.ports.first.number} {",
                                                        "  server #{SERVER_ADDRESS[0]}:#{program.ports.first.number};",
                                                        "  server #{SERVER_ADDRESS[1]}:#{program.ports.first.number};",
                                                        "  server #{SERVER_ADDRESS[2]}:#{program.ports.first.number};",
                                                        "  server #{SERVER_ADDRESS[3]}:#{program.ports.first.number};",
                                                        '}',
                                                        'server {',
                                                        "  listen #{program.ports.first.number};",
                                                        "  proxy_pass #{program.identification_name}_#{program.ports.first.number};",
                                                        '}'
                                                      ])
    }
  end

  context 'when instance does not have program' do
    let!(:instance) { FactoryGirl::create :instance }
    it {
      expect(described_class.new(instance).call).to eq([])
    }
  end
end