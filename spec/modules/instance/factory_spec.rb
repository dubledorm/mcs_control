require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::Factory do
  include DatabaseTools

  describe 'build' do
    it 'should not to raise error' do
      expect{Instance::Factory::build('test-milandr-chicken')}.to_not raise_error
    end

    it 'should create database for op' do
      Instance::Factory::build('test-milandr-chicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_op')).to be(true)
    end

    it 'should create database for mc' do
      Instance::Factory::build('test-milandr-chicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_mc')).to be(true)
    end

    it 'should create database for dcs' do
      Instance::Factory::build('test-milandr-chicken')
      expect(get_database_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_dcs4')).to be(true)
    end

    it 'program.db_status should set to everywhere_exists' do
      instance = Instance::Factory::build('test-milandr-chicken')
      expect(instance.db_status).to eq('everywhere_exists')
    end
  end
end
