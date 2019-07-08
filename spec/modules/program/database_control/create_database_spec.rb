require 'rails_helper_without_transactions'
require 'database_tools'

describe Program::DatabaseControl::CreateDatabase do
  include DatabaseTools

  before :each do
    @instance = Instance.new(name: 'testmilandrchicken')

    Instance::DatabaseControl::DbPrepare.build(@instance)

    @instance.save
  end

  describe 'standard call' do
    let(:program) {FactoryGirl.build :program,
                                      instance: @instance,
                                      program_type: 'mc'
                   }

    it 'should not to raise error' do
      expect {
        Program::DatabaseControl::CreateDatabase.build(program)
      }.not_to raise_error
    end

    it 'should create database' do
      Program::DatabaseControl::CreateDatabase.build(program)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken')).to be(true)
    end

    it 'should grant access to user' do
      Program::DatabaseControl::CreateDatabase.build(program)

      cmd = "psql -h #{Rails.configuration.database_configuration[Rails.env]["host"]}" +
            " -U #{program.instance.db_user_name} -w" +
            " -c \'create table milandr_test_1 (id integer);\' #{program.database_name}"
      puts cmd
      expect(`#{cmd}`).to eq("CREATE TABLE\n")
    end
  end

  describe 'database already exists' do
    let(:program) {FactoryGirl.build :program,
                                     instance: @instance,
                                     program_type: 'mc'
    }

    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_database(ActiveRecord::Base.connection, 'mc_testmilandrchicken')
    end

    it 'should create database' do
      Program::DatabaseControl::CreateDatabase.build(program)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken_1')).to be(true)
    end
  end
end
