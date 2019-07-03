require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::DatabaseControl::DbPrepare do
  include DatabaseTools

  describe 'standard call' do
    let(:instance) {FactoryGirl.build :instance, name: 'test-milandr-chicken'}

    it 'should not to raise error' do
      expect {Instance::DatabaseControl::DbPrepare.build(instance)}.not_to raise_error
    end

    it 'should create right user name' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::DbPrepare.build(instance)
      # noinspection SpellCheckingInspection
      expect(instance.db_user_name).to eq('test_milandr_chicken')
    end


    it 'should create database user' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::DbPrepare.build(instance)
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('test_milandr_chicken')).to be(true)
    end
  end

  describe 'database user already exists' do
    let(:instance) {FactoryGirl.build :instance, name: 'test-milandr-chicken'}

    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_user(ActiveRecord::Base.connection, 'test_milandr_chicken', 'test_milandr_chicken')
    end

    it 'should create database user' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::DbPrepare.build(instance)
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_1')).to be(true)
    end
  end
end
