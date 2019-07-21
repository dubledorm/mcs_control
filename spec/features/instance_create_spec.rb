#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature '#Create', js: true do
  include FeatureHelper
  include DatabaseTools

  before :each do
    admin_login
  end

  context 'when need_database_create is true' do
    it 'should redirect to show action' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      click_button value: 'Create Инстанс'
      sleep(10)
      expect(current_path).to eq(admin_instance_path(id: Instance.first.id))
    end

    it 'should create databases and user' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      click_button value: 'Create Инстанс'
      sleep(8)
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrtest')).to be(true)
      expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrtest')).to be(true)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest')).to be(true)
      expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrtest')).to be(true)
    end
  end

  context 'when need_database_create is false' do
    it 'should redirect to show action' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      uncheck id: 'need_database_create'
      click_button value: 'Create Инстанс'
      sleep(5)
      expect(current_path).to eq(admin_instance_path(id: Instance.first.id))
    end

    it 'should create user but no databases' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      uncheck id: 'need_database_create'
      click_button value: 'Create Инстанс'
      sleep(8)
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrtest')).to be(true)
      expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrtest')).to be(false)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest')).to be(false)
      expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrtest')).to be(false)
    end
  end

  context 'when exception call during build databases' do
    before :each do
      allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )
    end

    it 'should render new' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      click_button value: 'Create Инстанс'
      sleep(5)
      expect(current_path).to eq(admin_instances_path)
    end

    it 'should has error message' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      click_button value: 'Create Инстанс'
      sleep(5)
      expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
    end

    it 'should not increase Instance.count' do
      expect {
        visit new_admin_instance_path
        fill_in id: 'instance_name', with: 'testmilandrtest'
        click_button value: 'Create Инстанс'
        sleep(5)
      }.to change(Instance, :count).by(0)
    end

    it 'should not create database and user' do
      visit new_admin_instance_path
      fill_in id: 'instance_name', with: 'testmilandrtest'
      click_button value: 'Create Инстанс'
      sleep(5)
      expect(get_database_users_list(ActiveRecord::Base.connection).include?('testmilandrtest')).to be(false)
      expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrtest')).to be(false)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrtest')).to be(false)
      expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrtest')).to be(false)
    end
  end
end