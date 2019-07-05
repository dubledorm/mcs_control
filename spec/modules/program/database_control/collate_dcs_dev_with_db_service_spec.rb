require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Program::DatabaseControl::CollateDcsDevWithDbService do
  include DatabaseTools
  describe 'only_here_exists' do
    include_context 'instance with content'

    before :each do
      config   = Rails.configuration.database_configuration
      program_op.database_name = 'op_infosphera_test'
      instance.db_user_name = config[Rails.env]["admin_username"]
      instance.db_user_password = config[Rails.env]["admin_password"]
      program_op.save!

      Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
      program_dev.reload
    end

    it {expect(program_dev.ports.count).to eq(1)}

  end


  describe 'exception' do
    include_context 'instance with content'

    describe 'only dcs dev' do
      before :each do
        config   = Rails.configuration.database_configuration
        program_op.database_name = 'op_infosphera_test'
        instance.db_user_name = config[Rails.env]["admin_username"]
        instance.db_user_password = config[Rails.env]["admin_password"]
        program_op.save!
      end

      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_cli).call}.to raise_error ArgumentError}
    end


    describe 'not found op' do
      include_context 'instance with content'

      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call}.to raise_error StandardError}
    end
  end


  # and_return( [{'input_value' => '9003', 'serial_number' => 'serial1', 'device_type' => '4'},
  #              {'input_value' => '9004', 'serial_number' => 'serial2', 'device_type' => '4'},
  #              {'input_value' => '9005', 'serial_number' => 'serial3', 'device_type' => '4'}
  #             ] )


  describe 'collate' do
    include_context 'instance with content'

    describe 'empty here' do

      it 'empty there' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return([])

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}).to eq([])
      end

      it 'should add ports here' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return([9003, 9004, 9005])

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}).to eq([[9003, :only_there_exists],
                                                                                            [9004, :only_there_exists],
                                                                                            [9005, :only_there_exists]])
      end
    end


    describe 'here exists' do
      let!(:port1) {FactoryGirl.create :port, number: 9003, instance: instance, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}
      let!(:port2) {FactoryGirl.create :port, number: 9004, instance: instance, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}
      let!(:port3) {FactoryGirl.create :port, number: 9005, instance: instance, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}

      it 'should change db_status to only_here_exists' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return([])

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}).to eq([[9003, :only_here_exists],
                                                                                            [9004, :only_here_exists],
                                                                                            [9005, :only_here_exists]])
      end

      it 'should add port' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return([9005, 9006])

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}).to eq([[9003, :only_here_exists],
                                                                                            [9004, :only_here_exists],
                                                                                            [9005, :everywhere_exists],
                                                                                            [9006, :only_there_exists]
                                                                                           ])
      end
    end
  end
end
