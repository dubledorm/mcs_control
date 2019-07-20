require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Program::DatabaseControl::CollateDcsDevWithDbService do
  include DatabaseTools

  describe 'call of service - trye and wrong' do
    include_context 'instance with content'

    context 'when program`s database exists and has one port' do
      before :each do
        config   = Rails.configuration.database_configuration
        program_op.database_name = 'op_infosphera_test'
        instance.db_user_name = config[Rails.env]["admin_username"]
        instance.db_user_password = config[Rails.env]["admin_password"]
        program_op.save!

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
      end

      it {expect(program_dev.ports.count).to eq(1)} # Создаём одни порт
    end


    context 'when call the service for something else than dcs_dev' do # Работает только для dcs_dev
      before :each do
        config   = Rails.configuration.database_configuration
        program_op.database_name = 'op_infosphera_test'
        instance.db_user_name = config[Rails.env]["admin_username"]
        instance.db_user_password = config[Rails.env]["admin_password"]
        program_op.save!
      end

      # Должно генерить exception
      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_cli).call}.to raise_error ArgumentError}
    end

    context 'when database op does not exists' do # Когда не находим базу op, где лежат порты для dcs_dev

      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call}.to raise_error StandardError}
    end
  end

  describe 'work of the service' do
    include_context 'instance with content'

    context 'when no ports is in op_databases' do # Нет ни одного порта в БД

      it 'should not create any port' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return([])

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}).to eq([])
      end
    end

    context 'when database has 3 ports' do
      it 'should add ports here' do
        allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
            and_return( [{'input_value' => '9003', 'serial_number' => 'serial1', 'device_type' => '4'},
                         {'input_value' => '9004', 'serial_number' => 'serial2', 'device_type' => '4'},
                         {'input_value' => '9005', 'serial_number' => 'serial3', 'device_type' => '4'}
                        ] )

        Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
        program_dev.reload
        expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}.sort).to eq([[9003, :only_there_exists],
                                                                                                 [9004, :only_there_exists],
                                                                                                 [9005, :only_there_exists]
                                                                                                ].sort)
      end
    end


    context 'when here already exist 3 port' do
      let!(:port1) {FactoryGirl.create :port, number: 9003, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}
      let!(:port2) {FactoryGirl.create :port, number: 9004, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}
      let!(:port3) {FactoryGirl.create :port, number: 9005, program: program_dev,
                                      port_type: 'tcp', db_status: :undefined}


      context 'when in op_database ports do not exist' do
        it 'should change db_status to only_here_exists' do
          allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
              and_return([])

          Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
          program_dev.reload
          expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}.sort).to eq([[9003, :only_here_exists],
                                                                                                   [9004, :only_here_exists],
                                                                                                   [9005, :only_here_exists]
                                                                                                  ].sort)
        end
      end

      context 'when in op_database exist some ports' do
        it 'should add port' do
          allow_any_instance_of(Program::DatabaseControl::CollateDcsDevWithDbService).to receive(:get_there_object_list).
              and_return( [{'input_value' => '9006', 'serial_number' => 'serial1', 'device_type' => '4'},
                           {'input_value' => '9005', 'serial_number' => 'serial3', 'device_type' => '4'}
                          ] )


          Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
          program_dev.reload
          expect(program_dev.ports.to_a.map{|port| [port.number, port.sym_db_status]}.sort).to eq([[9003, :only_here_exists],
                                                                                                   [9004, :only_here_exists],
                                                                                                   [9005, :everywhere_exists],
                                                                                                   [9006, :only_there_exists]
                                                                                                  ].sort)
        end
      end
    end
  end
end
