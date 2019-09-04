#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'support/shared/role_manager_shared_examples'

RSpec.feature 'Role Manager', js: true do
  include FeatureHelper
  let!(:instances) { FactoryGirl.create_list(:full_instance, 4) }

  describe '#Instans' do
    before :each do
      manager_login
      @user.add_role :manager, instances[2]
      @user.add_role :manager, instances[3]
    end

    it_should_behave_like 'any authorised user for instance'

    it 'should not edit yourself records' do
      visit edit_admin_instance_path(id: instances[2])
      expect(page).to have_content('Вы не авторизованы для выполнения данного действия')
    end
  end

  describe '#Programs' do
    before :each do
      manager_login
      @user.add_role :manager, instances[2]
      @user.add_role :manager, instances[3]
    end

    it_should_behave_like 'any authorised user for program'

    # it 'should not edit yourself records' do
    #   visit edit_admin_instance_path(id: instances[2])
    #   expect(page).to have_content('Вы не авторизованы для выполнения данного действия')
    # end
  end
end