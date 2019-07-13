require 'rails_helper_without_transactions'
require 'database_tools'

describe DatabaseTools do
  include DatabaseTools

  describe 'get_database_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create database mc_testmilandrchicken")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_test' do
      expect(get_database_list(ActiveRecord::Base.connection ).include?('mc_testmilandrchicken')).to be(true)
    end
  end


  describe 'create database' do
    it { expect{create_database(ActiveRecord::Base.connection, 'mc_testmilandrchicken' )}.not_to raise_error }

    it 'should generate exception if database already exists' do
      create_database(ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      expect{create_database(ActiveRecord::Base.connection, 'op_testmilandrchicken' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end


  describe 'drop database' do
    it 'should not generate exception if database exists' do
      create_database(ActiveRecord::Base.connection, 'dcs4_testmilandrchicken_1' )
      expect{drop_database(ActiveRecord::Base.connection, 'dcs4_testmilandrchicken_1' )}.not_to raise_error
    end

    it 'should generate exception if database does not exists' do
      expect{drop_database(ActiveRecord::Base.connection, 'dcs4_testmilandrchicken_1' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end

  describe 'get_database_users_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create user testmilandrchicken_user")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_users_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_user' do
      expect(get_database_users_list(ActiveRecord::Base.connection ).include?('testmilandrchicken_user')).to be(true)
    end
  end


  describe 'create_user' do
    it { expect{create_user(ActiveRecord::Base.connection, 'testmilandrchicken_user' )}.not_to raise_error }
    it { expect{create_user(ActiveRecord::Base.connection, 'testmilandrchicken_user', 'password' )}.not_to raise_error }
    it 'should create user' do
      create_user(ActiveRecord::Base.connection, 'testmilandrchicken_user' )
      expect(get_database_users_list(ActiveRecord::Base.connection ).include?('testmilandrchicken_user')).to be(true)
    end

    it { expect{create_user(ActiveRecord::Base.connection, '1111' )}.to raise_error ActiveRecord::StatementInvalid}
  end

  describe 'drop_user' do
    before :each do
      create_user(ActiveRecord::Base.connection, 'testmilandrchicken_user' )
    end

    it {expect(get_database_users_list(ActiveRecord::Base.connection ).include?('testmilandrchicken_user')).to be(true)}

    it 'should drop database role' do
      drop_user(ActiveRecord::Base.connection, 'testmilandrchicken_user' )
      expect(get_database_users_list(ActiveRecord::Base.connection ).include?('testmilandrchicken_user')).to be(false)
    end
  end
end
