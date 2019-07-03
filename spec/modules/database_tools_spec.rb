require 'rails_helper_without_transactions'
require 'database_tools'

describe DatabaseTools do
  include DatabaseTools

  describe 'get_database_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create database test_milandr_chicken")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_test' do
      expect(get_database_list(ActiveRecord::Base.connection ).include?('test_milandr_chicken')).to be(true)
    end
  end


  describe 'create database' do
    it { expect{create_database(ActiveRecord::Base.connection, 'test_milandr_chicken' )}.not_to raise_error }

    it 'should generate exception if database already exists' do
      create_database(ActiveRecord::Base.connection, 'test_milandr_chicken' )
      expect{create_database(ActiveRecord::Base.connection, 'test_milandr_chicken' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end


  describe 'drop database' do
    it 'should not generate exception if database exists' do
      create_database(ActiveRecord::Base.connection, 'test_milandr_chicken_mc_1' )
      expect{drop_database(ActiveRecord::Base.connection, 'test_milandr_chicken_mc_1' )}.not_to raise_error
    end

    it 'should generate exception if database does not exists' do
      expect{drop_database(ActiveRecord::Base.connection, 'test_milandr_chicken_mc_1' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end

  describe 'get_database_users_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create user test_milandr_chicken_user")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_users_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_user' do
      expect(get_database_users_list(ActiveRecord::Base.connection ).include?('test_milandr_chicken_user')).to be(true)
    end
  end


  describe 'create_user' do
    it { expect{create_user(ActiveRecord::Base.connection, 'test_milandr_chicken_user' )}.not_to raise_error }
    it { expect{create_user(ActiveRecord::Base.connection, 'test_milandr_chicken_user', 'password' )}.not_to raise_error }
  end
end
