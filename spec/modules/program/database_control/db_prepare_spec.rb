require 'rails_helper_without_transactions'
require 'database_tools'

describe Program::DatabaseControl::DbPrepare do
  include DatabaseTools

  before :each do
    @instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
    @instance_control.prepare
    @instance_control.call
  end

  describe 'standard call' do
    let(:program) {FactoryGirl.build :program,
                                      instance: @instance_control.instance,
                                      program_type: 'mc'
                   }

    it 'should not to raise error' do
      expect {
        Program::DatabaseControl::DbPrepare.build(program)
      }.not_to raise_error
    end

    it 'should create database' do
      Program::DatabaseControl::DbPrepare.build(program)
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_mc')).to be(true)
    end

    it 'should grant access to user' do
      Program::DatabaseControl::DbPrepare.build(program)

      cmd = "psql -h #{Rails.configuration.database_configuration[Rails.env]["host"]}" +
            " -U #{program.instance.db_user_name} -w" +
            " -c \'create table milandr_test_1 (id integer);\' #{program.database_name}"
      puts cmd
      expect(`#{cmd}`).to eq("CREATE TABLE\n")
    end
  end

  describe 'database already exists' do
    let(:program) {FactoryGirl.build :program,
                                     instance: @instance_control.instance,
                                     program_type: 'mc'
    }

    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_database(ActiveRecord::Base.connection, 'test_milandr_chicken_mc')
    end

    it 'should create database' do
      Program::DatabaseControl::DbPrepare.build(program)
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_mc_1')).to be(true)
    end
  end
end
