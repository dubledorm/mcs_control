#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature '#Check', js: true do
  include FeatureHelper
  include DatabaseTools

  before :each do
    @instance =  Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
    admin_login
  end

  context 'when all ok' do
    it 'should write notice - Checked' do
      visit admin_instance_path(id: @instance.id)
      click_link 'Сверить с БД'
      sleep(3)
      expect(page.has_css?('.flash.flash_notice', text: 'Checked!')).to be(true)
    end
  end

  context 'when exception call during destroy' do
    before :each do
      allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )
    end

    it 'should has error message' do
      visit admin_instance_path(id: @instance.id)
      click_link 'Сверить с БД'
      sleep(3)
      expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
   end
  end
end
