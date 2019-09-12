require 'rails_helper'
require 'support/feature_helper'
require 'database_tools'
require 'nginx_config'

SERVER_ADDRESS = %w(192.168.100.11 192.168.100.12 192.168.100.14 192.168.100.24).freeze

RSpec.describe Program::Export::NginxHttpService do
  context 'when program has a port but no http type' do
    let!(:program) { FactoryGirl::create :dev_program }

    it {
      expect(described_class.new(program).call).to eq([])
    }
  end

  context 'when program has one port of http type' do
    let!(:program) { FactoryGirl::create :mc_program }

    it {
      expect(described_class.new(program).call).to eq([ "upstream #{program.identification_name}_#{program.ports[0].number} {",
                                                        "  server #{SERVER_ADDRESS[0]}:#{program.ports[0].number};",
                                                        "  server #{SERVER_ADDRESS[1]}:#{program.ports[0].number};",
                                                        "  server #{SERVER_ADDRESS[2]}:#{program.ports[0].number};",
                                                        "  server #{SERVER_ADDRESS[3]}:#{program.ports[0].number};",
                                                        '}',
                                                        'server {',
                                                        "  listen #{program.ports[0].number};",
                                                        '  server_name infsphr.info;',
                                                        '  location = / {',
                                                        '  rewrite ^.+ /mc permanent;',
                                                        '  }',
                                                        '  location /mc {',
                                                        "  proxy_pass http://#{program.identification_name};",
                                                        '  }',
                                                        '}'
                                                      ])
    }
  end
end


RSpec.describe Instance::Export::NginxHttpService do
  context 'when instance does not have program' do
    let!(:instance) { FactoryGirl::create :instance }
    it {
      expect(described_class.new(instance).call).to eq([])
    }
  end

  context 'when instance has one mc program' do
    let!(:program) { FactoryGirl::create :mc_program }

    it {
      expect(described_class.new(program.instance).call).to eq([ "upstream #{program.identification_name}_#{program.ports[0].number} {",
                                                                 "  server #{SERVER_ADDRESS[0]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[1]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[2]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[3]}:#{program.ports[0].number};",
                                                                 '}',
                                                                 'server {',
                                                                 "  listen #{program.ports[0].number};",
                                                                 '  server_name infsphr.info;',
                                                                 '  location = / {',
                                                                 '  rewrite ^.+ /mc permanent;',
                                                                 '  }',
                                                                 '  location /mc {',
                                                                 "  proxy_pass http://#{program.identification_name};",
                                                                 '  }',
                                                                 '}'
                                                               ])
    }
  end

  context 'when instance has one op program' do
    let!(:program) { FactoryGirl::create :op_program }

    it {
      expect(described_class.new(program.instance).call).to eq([ "upstream #{program.identification_name}_#{program.ports[0].number} {",
                                                                 "  server #{SERVER_ADDRESS[0]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[1]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[2]}:#{program.ports[0].number};",
                                                                 "  server #{SERVER_ADDRESS[3]}:#{program.ports[0].number};",
                                                                 '}',
                                                                 'server {',
                                                                 "  listen #{program.ports[0].number};",
                                                                 '  server_name infsphr.info;',
                                                                 '  location = / {',
                                                                 '  rewrite ^.+ /operator permanent;',
                                                                 '  }',
                                                                 '  location /operator {',
                                                                 "  proxy_pass http://#{program.identification_name};",
                                                                 '  }',
                                                                 '}'
                                                               ])
    }
  end
end