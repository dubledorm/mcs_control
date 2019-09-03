#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'support/shared/role_manager_shared_examples'

RSpec.feature 'Role Editor', js: true do
  include FeatureHelper
  let!(:instances) { FactoryGirl.create_list(:full_instance, 4) }


  describe '#Instans' do
    before :each do
      manager_login
      @user.add_role :editor, instances[2]
      @user.add_role :editor, instances[3]
    end

    it_should_behave_like 'any authorised user for instance'

    it 'should edit yourself records' do
      visit edit_admin_instance_path(id: instances[2])
      fill_in id: 'instance_description', with: 'testmilandrtest'
      click_button value: 'Update Инстанс'
      sleep(10)
      expect(current_path).to eq(admin_instance_path(id: instances[2]))
    end
  end
end