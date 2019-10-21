require 'rails_helper_without_transactions'
require 'database_tools'

describe Program::Factory do
  include DatabaseTools

  shared_examples 'create program and database' do
    it 'should create program' do
      expect{Program::Factory::build_and_create_db(instance, program_type, true, additional_name)}.to change(Program, :count).by(1)
    end

    it 'should create database' do
      Program::Factory::build_and_create_db(instance, program_type, true, additional_name)
      database_name = program_type == 'dcs-cli' ? 'dcs4' : program_type
      database_name += '_testmilandrchicken'
      database_name += '_' + additional_name unless additional_name.blank?
      # noinspection SpellCheckingInspection
      expect(get_database_list(ActiveRecord::Base.connection).include?(database_name)).to be(true)
    end

    it 'should not create database' do
      expect {
        Program::Factory::build_and_create_db(instance, program_type, false, additional_name)
      }.to change(get_database_list(ActiveRecord::Base.connection), :count).by(0)
    end

    it 'should grant access to user' do
      program = Program::Factory::build_and_create_db(instance, program_type, true, additional_name)
      cmd = "psql -h #{Rails.configuration.database_configuration[Rails.env]["host"]}" +
             " -U #{program.instance.db_user_name} -w" +
             " -c \'create table milandr_test_1 (id integer);\' #{program.database_name}"
      puts cmd
      expect(`#{cmd}`).to eq("CREATE TABLE\n")
    end

    it 'program.db_status should set to everywhere_exists' do
      program = Program::Factory::build_and_create_db(instance, program_type, true, additional_name)
      expect(program.db_status).to eq('everywhere_exists')
    end
  end

  shared_examples 'create http port' do

    it 'should create port' do
      expect{Program::Factory::build_and_create_db(instance, program_type, true, additional_name)}.to change(Port, :count).by(1)
    end

    it 'should not create port' do
      expect{Program::Factory::build_and_create_db(instance, program_type, false, additional_name)}.to change(Port, :count).by(0)
    end

    it 'should http port' do
      Program::Factory::build_and_create_db(instance, program_type, additional_name)
      port = Port.first
      expect(port.port_type).to eq('http')
    end
  end

  shared_examples 'create tcp port' do

    it 'should create port' do
      expect{Program::Factory::build_and_create_db(instance, program_type, true, additional_name)}.to change(Port, :count).by(1)
    end

    it 'should not create port' do
      expect{Program::Factory::build_and_create_db(instance, program_type, false, additional_name)}.to change(Port, :count).by(0)
    end

    it 'should tcp port' do
      Program::Factory::build_and_create_db(instance, program_type, additional_name)
      port = Port.first
      expect(port.port_type).to eq('tcp')
    end
  end

  shared_examples 'no port' do

    it 'no port' do
      expect{Program::Factory::build_and_create_db(instance, program_type, true, additional_name)}.to change(Port, :count).by(0)
    end
  end


  shared_examples 'program and http port' do
    it_should_behave_like 'create program and database'
    it_should_behave_like 'create http port'
  end


  shared_examples 'program and no port' do
    it_should_behave_like 'create program and database'
    it_should_behave_like 'no port'
  end

  shared_examples 'program no database and tcp port' do
    it 'should create program' do
      expect{Program::Factory::build_and_create_db(instance, program_type, true, additional_name)}.to change(Program, :count).by(1)
    end
    it_should_behave_like 'create tcp port'
  end


  describe '#build_and_create_db' do
    before :each do
      @instance = Instance.new(name: 'testmilandrchicken')
      Instance::DatabaseControl::CreateUser.build(@instance)
      @instance.save
    end

    context 'when database does not exist yet' do

      it_should_behave_like 'program and http port' do
        let(:instance) {@instance}
        let(:program_type) {'mc'}
        let(:additional_name) {''}
      end

      it_should_behave_like 'program and http port' do
        let(:instance) {@instance}
        let(:program_type) {'op'}
        let(:additional_name) {''}
      end

      it_should_behave_like 'program no database and tcp port' do
        let(:instance) {@instance}
        let(:program_type) {'dcs-dev'}
        let(:additional_name) {''}
      end

      it_should_behave_like 'program and no port' do
        let(:instance) {@instance}
        let(:program_type) {'dcs-cli'}
        let(:additional_name) {''}
      end

      it_should_behave_like 'program and http port' do
        let(:instance) {@instance}
        let(:program_type) {'mc'}
        let(:additional_name) {'add'}
      end

      it_should_behave_like 'program and http port' do
        let(:instance) {@instance}
        let(:program_type) {'op'}
        let(:additional_name) {'add'}
      end

      it_should_behave_like 'program no database and tcp port' do
        let(:instance) {@instance}
        let(:program_type) {'dcs-dev'}
        let(:additional_name) {'add'}
      end

      it_should_behave_like 'program and no port' do
        let(:instance) {@instance}
        let(:program_type) {'dcs-cli'}
        let(:additional_name) {'add'}
      end
    end

    context 'when create pf2' do
      it 'should not create database and create two tcp ports' do
        expect{ Program::Factory::build_and_create_db(@instance, 'pf2',
                                                      true, '')}.to change(Program, :count).by(1)
      end

      it 'should create 2 ports' do
        expect{Program::Factory::build_and_create_db(@instance, 'pf2',
                                                     true, '')}.to change(Port, :count).by(2)
      end

      it 'should not create any port' do
        expect{Program::Factory::build_and_create_db(@instance, 'pf2',
                                                     false, '')}.to change(Port, :count).by(0)
      end

    end

    context 'when database already exists' do
      let(:instance) {@instance}
      let(:program_type) {'mc'}
      let(:additional_name) {''}

      before :each do
        # noinspection SpellCheckingInspection,SpellCheckingInspection
        create_database(ActiveRecord::Base.connection, 'mc_testmilandrchicken')
      end

      it 'should create database with additional number' do
        Program::Factory::build_and_create_db(instance, program_type, true, additional_name)
        expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken_1')).to be(true)
      end
    end
  end
end
