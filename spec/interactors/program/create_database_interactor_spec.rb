require 'rails_helper_without_transactions'
require 'database_tools'

describe Program do
  include DatabaseTools

  describe 'standard call' do
    let!(:instance) {FactoryGirl.create :instance, name: 'test-milandr-chicken' }
    let!(:program) {FactoryGirl.create :program, program_type: 'mc',
                                       instance: instance,
                                       identification_name: 'test-milandr-chicken-mc',
                                       database_name: 'test_milandr_chicken_mc'}
    

    it 'should not generate exception' do
      # noinspection SpellCheckingInspection
      expect{Program::CreateDatabaseInteractor.call(program: program)}.not_to raise_error
    end

    it 'should create database test_milandr_chicken_mc' do
      Program::CreateDatabaseInteractor.call(program: program)
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_mc'))
    end

    it 'should return fail for error' do
      program.database_name = nil
      expect(Program::CreateDatabaseInteractor.call(program: program).failure?).to be(true)
    end

    it 'should return error code' do
      program.database_name = nil
      result = Program::CreateDatabaseInteractor.call(program: program)
      puts 'Отладочная печать: '
      puts result.message
      expect(result.message).to_not eq('')
    end

    # it 'should grant access user to the database' do
    #   Instance::CreateDbUserInteractor.call(instance: instance)
    #   Program::CreateDatabaseInteractor.call(program: program)
    #   cmd = "psql -h #{Rails.configuration.database_configuration[Rails.env]["host"]}" +
    #         " -U #{instance.db_user_name} -W #{instance.db_user_password}" +
    #         " -c \'create table milandr_test_1 (id integer);\' #{program.database_name}"
    #   puts cmd
    #   expect(`#{cmd}`).to eq("CREATE TABLE\n")
    # end
  end
end
