require 'rails_helper_without_transactions'
require 'database_tools'

describe DatabaseControl::InstanceControl do
  include DatabaseTools

  describe 'standard call' do

    it 'should not to raise error' do
      expect {
        instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
        instance_control.prepare
        instance_control.call
      }.not_to raise_error
    end

    it 'should create instance' do
      expect {
        # noinspection SpellCheckingInspection
        instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
        instance_control.prepare
        instance_control.call
      }.to change(Instance, :count).by(1)
    end


    it 'should create right user name' do
      # noinspection SpellCheckingInspection
      instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
      instance_control.prepare
      instance_control.call
      # noinspection SpellCheckingInspection
      expect(instance_control.instance.db_user_name).to eq('test_milandr_chicken')
    end


    it 'should create database user' do
      # noinspection SpellCheckingInspection
      instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
      instance_control.prepare
      instance_control.call
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('test_milandr_chicken')).to be(true)
    end
  end

  describe 'database user already exists' do
    before :each do
      # noinspection SpellCheckingInspection,SpellCheckingInspection
      create_user(ActiveRecord::Base.connection, 'test_milandr_chicken', 'test_milandr_chicken')
    end

    it 'should create database user' do
      # noinspection SpellCheckingInspection
      instance_control = DatabaseControl::InstanceControl.new('test-milandr-chicken')
      instance_control.prepare
      instance_control.call
      # noinspection SpellCheckingInspection
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('test_milandr_chicken_1')).to be(true)
    end
  end



end
