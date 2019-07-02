require 'rails_helper_without_transactions'
require 'database_tools'

describe Program::Factory do
  include DatabaseTools

  before :each do
    @instance = Instance.new(name: 'test-milandr-chicken')

    Instance::DatabaseControl::DbPrepare.build(@instance)

    @instance.save
  end

  shared_examples 'create program and database' do
    it 'should create program' do
      expect{Program::Factory::build(instance, program_type, additional_name)}.to change(Program, :count).by(1)
    end

    it 'should create database' do
      Program::Factory::build(instance, program_type, additional_name)
      database_name = 'test_milandr_chicken_'
      database_name += program_type == 'dcs-cli' ? 'dcs4' : program_type
      database_name += '_' + additional_name unless additional_name.blank?
      # noinspection SpellCheckingInspection
      expect(get_database_list(ActiveRecord::Base.connection).include?(database_name)).to be(true)
    end

    it 'should grant access to user' do
      program = Program::Factory::build(instance, program_type, additional_name)
      cmd = "psql -h #{Rails.configuration.database_configuration[Rails.env]["host"]}" +
             " -U #{program.instance.db_user_name} -w" +
             " -c \'create table milandr_test_1 (id integer);\' #{program.database_name}"
      puts cmd
      expect(`#{cmd}`).to eq("CREATE TABLE\n")
    end
  end

  shared_examples 'create http port' do

    it 'should create port' do
      expect{Program::Factory::build(instance, program_type, additional_name)}.to change(Port, :count).by(1)
    end

    it 'should http port' do
      Program::Factory::build(instance, program_type, additional_name)
      port = Port.first
      expect(port.port_type).to eq('http')
    end
  end

  shared_examples 'create tcp port' do

    it 'should create port' do
      expect{Program::Factory::build(instance, program_type, additional_name)}.to change(Port, :count).by(1)
    end

    it 'should tcp port' do
      Program::Factory::build(instance, program_type, additional_name)
      port = Port.first
      expect(port.port_type).to eq('tcp')
    end
  end

  shared_examples 'no port' do

    it 'no port' do
      expect{Program::Factory::build(instance, program_type, additional_name)}.to change(Port, :count).by(0)
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
      expect{Program::Factory::build(instance, program_type, additional_name)}.to change(Program, :count).by(1)
    end
    it_should_behave_like 'create tcp port'
  end


  describe 'build' do

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

  describe 'database already exists' do
    let(:instance) {@instance}
    let(:program_type) {'mc'}
    let(:additional_name) {''}
    
    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_database(ActiveRecord::Base.connection, 'test_milandr_chicken_mc')
    end

    it 'should create database with additional number' do
      Program::Factory::build(instance, program_type, additional_name)
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_mc_1')).to be(true)
    end
  end
end
