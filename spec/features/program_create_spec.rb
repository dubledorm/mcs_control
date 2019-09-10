#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature '#Create', js: true do
  include FeatureHelper
  include DatabaseTools
  let!(:instance) { FactoryGirl.create :instance, name: 'testmilandrtest' }

  before :each do
    Instance::Factory::build(instance)
    admin_login
  end

  context 'when need_database_create is true' do
    before :each do
      visit new_admin_instance_program_path(instance_id: instance, program_type: 'mc')
      fill_in id: 'program_additional_name', with: 'add'
      check id: 'need_database_create'
      click_button value: 'Create Программа'
      sleep(10)
    end

    it 'should redirect to show action' do
      expect(current_path).to eq(admin_instance_program_path(instance_id: instance, id: Program.first.id))
    end

    it 'should create databases and user' do
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrtest')).to be(true)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest_add')).to be(true)
    end
  end

  context 'when need_database_create is false' do
    before :each do
      visit new_admin_instance_program_path(instance_id: instance, program_type: 'mc')
      fill_in id: 'program_additional_name', with: 'add'
      click_button value: 'Create Программа'
      sleep(10)
    end

    it 'should redirect to show action' do
      expect(current_path).to eq(admin_instance_program_path(instance_id: instance, id: Program.first.id))
    end

    it 'should not create database' do
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest_add')).to be(false)
    end
  end

  context 'when exception call during build databases' do
    before :each do
      allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )

      visit new_admin_instance_program_path(instance_id: instance, program_type: 'mc')
      fill_in id: 'program_additional_name', with: 'add'
      click_button value: 'Create Программа'
      sleep(5)
    end

    it 'should render new' do
      expect(current_path).to eq(new_admin_instance_program_path(instance_id: instance))
    end

    it 'should has error message' do
      expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
    end

    it 'should not increase Program.count' do
      expect(Program.count).to eq(0)
    end

    it 'should not create database' do
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest_add')).to be(false)
    end
  end
end