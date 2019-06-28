require 'rails_helper_without_transactions'
require 'database_tools'

describe DatabaseTools do
  include DatabaseTools

  describe 'get_database_users_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create database chicken_test")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_test' do
      expect(get_database_list(ActiveRecord::Base.connection ).include?('chicken_test')).to be(true)
    end
  end


  describe 'create database' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("drop database chicken_mc_1")
      rescue
      end
    end

    it { expect{create_database(ActiveRecord::Base.connection, 'chicken_mc_1' )}.not_to raise_error }

    it 'should generate exception if database already exists' do
      create_database(ActiveRecord::Base.connection, 'chicken_mc_1' )
      expect{create_database(ActiveRecord::Base.connection, 'chicken_mc_1' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end


  describe 'drop database' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("drop database chicken_mc_1")
      rescue
      end
    end

    it 'should not generate exception if database exists' do
      create_database(ActiveRecord::Base.connection, 'chicken_mc_1' )
      expect{drop_database(ActiveRecord::Base.connection, 'chicken_mc_1' )}.not_to raise_error
    end

    it 'should generate exception if database does not exists' do
      expect{drop_database(ActiveRecord::Base.connection, 'chicken_mc_1' )}.to raise_error ActiveRecord::StatementInvalid
    end
  end

  describe 'get_database_users_list' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("create user chicken_user")
      rescue
      end
    end

    it 'should not generate exception' do
      expect{get_database_users_list(ActiveRecord::Base.connection )}.not_to raise_error
    end

    it 'should find chicken_user' do
      expect(get_database_users_list(ActiveRecord::Base.connection ).include?('chicken_user')).to be(true)
    end
  end


  describe 'create_user' do
    before :each do
      # noinspection RubyEmptyRescueBlockInspection
      begin
        ActiveRecord::Base.connection.execute("drop user chicken_user")
      rescue
      end

      it { expect{create_user(ActiveRecord::Base.connection, 'chicken_user' )}.not_to raise_error }
      it { expect{create_user(ActiveRecord::Base.connection, 'chicken_user', 'password' )}.not_to raise_error }
    end
  end
end
