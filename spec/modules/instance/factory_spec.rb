require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::Factory do
  include DatabaseTools

  describe 'build' do
    it 'should not to raise error' do
      expect{Instance::Factory::build('testmilandrchicken')}.to_not raise_error
    end

    it 'should create database for op' do
      Instance::Factory::build('testmilandrchicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrchicken')).to be(true)
    end

    it 'should create database for mc' do
      Instance::Factory::build('testmilandrchicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken')).to be(true)
    end

    it 'should create database for dcs' do
      Instance::Factory::build('testmilandrchicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrchicken')).to be(true)
    end

    it 'program.db_status should set to everywhere_exists' do
      instance = Instance::Factory::build('testmilandrchicken')
      expect(instance.db_status).to eq('everywhere_exists')
    end
  end
end
