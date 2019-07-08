require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::DatabaseControl::CreateUser do
  include DatabaseTools

  describe 'standard call' do
    let(:instance) {FactoryGirl.build :instance, name: 'testmilandrchicken'}

    it 'should not to raise error' do
      expect {Instance::DatabaseControl::CreateUser.build(instance)}.not_to raise_error
    end

    it 'should create right user name' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::CreateUser.build(instance)
      # noinspection SpellCheckingInspection
      expect(instance.db_user_name).to eq('testmilandrchicken')
    end


    it 'should create database user' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::CreateUser.build(instance)
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrchicken')).to be(true)
    end
  end

  describe 'database user already exists' do
    let(:instance) {FactoryGirl.build :instance, name: 'testmilandrchicken'}

    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_user(ActiveRecord::Base.connection, 'testmilandrchicken', 'testmilandrchicken')
    end

    it 'should create database user' do
      # noinspection SpellCheckingInspection
      Instance::DatabaseControl::CreateUser.build(instance)
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrchicken_1')).to be(true)
    end
  end
end
