#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature '#Destroy', js: true do
  include FeatureHelper
  include DatabaseTools

  before :each do
    @instance =  Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
    admin_login
  end

  context 'when all ok' do
    it 'should redirect to admin_instances_path' do
      visit admin_instance_path(id: @instance.id)
      page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
      click_link 'Удалить Инстанс'
      sleep(3)
      click_link 'Удалить'
      sleep(3)
      expect(current_path).to eq(admin_instances_path)
    end
  end

  context 'when exception call during destroy' do
    before :each do
      allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )
    end

    it 'should redirect to admin_instance_path' do
      visit admin_instance_path(id: @instance.id)
      page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
      click_link 'Удалить Инстанс'
      sleep(3)
      click_link 'Удалить'
      sleep(3)
      expect(current_path).to eq(admin_instance_path(id: @instance.id))
    end

    it 'should has error message' do
      visit admin_instance_path(id: @instance.id)
      page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
      click_link 'Удалить Инстанс'
      sleep(3)
      click_link 'Удалить'
      sleep(3)
      expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
    end
  end
end
