require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::Factory do
  include DatabaseTools

  describe 'build and create db' do
    it 'should not to raise error' do
      expect{Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))}.to_not raise_error
    end

    it "should save instance" do
      expect{Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))}.to change(Instance, :count).by(1)
    end

    it 'should create database for op' do
      Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
      expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrchicken')).to be(true)
    end

    it 'should create database for mc' do
      Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken')).to be(true)
    end

    it 'should create database for dcs' do
      Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
      expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrchicken')).to be(true)
    end

    it 'program.db_status should set to everywhere_exists' do
      instance = Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
      instance.reload
      expect(instance.db_status).to eq('everywhere_exists')
    end
  end

  describe 'build' do
    it 'should not to raise error' do
      expect{Instance::Factory::build(Instance.new(name: 'testmilandrchicken'))}.to_not raise_error
    end

    it "should save instance" do
      expect{Instance::Factory::build(Instance.new(name: 'testmilandrchicken'))}.to change(Instance, :count).by(1)
    end

    it 'program.db_status should set to undefined' do
      instance = Instance::Factory::build(Instance.new(name: 'testmilandrchicken'))
      instance.reload
      expect(instance.db_status).to eq('undefined')
    end
  end
end
