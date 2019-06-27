require 'rails_helper_without_transactions'
require 'database_tools'

describe DatabaseTools do
  include DatabaseTools

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
end
