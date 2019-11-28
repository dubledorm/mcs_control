require 'rails_helper'

RSpec.describe Program::Export::NginxTemplateConverter do
  context 'simple functions' do
    let!(:ip_addresses) { ['192.168.1.1', '192.168.1.2']}
    let!(:ip_port) { '30001' }
    let!(:listen_ip_port) { '30001' }
    let!(:server_name) { 'infsphr.info' }
    let!(:program) { FactoryGirl::create :program, program_type: 'mc', identification_name: 'uniq' }

    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_uniq_section_name('12345')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_uniq_section_name('<uniq_section_name>')).
        to eq('uniq_mc')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_uniq_section_name('<uniq_section_name> <uniq_section_name>')).
        to eq('uniq_mc uniq_mc')}

    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_address('12345', 'uniq_name')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_address('<ip_address>', 'uniq_name')).to eq('uniq_name')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_address('<ip_address> <ip_address>',
                                                                       'uniq_name')).to eq('uniq_name uniq_name')}

    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_port('12345')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_port('<ip_port>')).to eq('30001')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_port('<ip_port> <ip_port>')).
        to eq('30001 30001')}

    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_program_type('12345')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_program_type('<program_type>')).to eq('mc')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_program_type('<program_type> <program_type>')).
        to eq('mc mc')}

    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_server_name('12345')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_server_name('<server_name>')).to eq('infsphr.info')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_server_name('<server_name> <server_name>')).
        to eq('infsphr.info infsphr.info')}


    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_addresses('12345')).to eq('12345')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_addresses("<ip_addresses>.each{}")).
        to eq('')}
    it { expect(described_class.new(server_name, ip_addresses, ip_port, listen_ip_port, program).convert_ip_addresses("<ip_addresses>.each{server <ip_address>:<ip_port>;\n}")).
        to eq("server 192.168.1.1:30001;\nserver 192.168.1.2:30001;\n")}

  end
end