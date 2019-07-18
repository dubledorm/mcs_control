#coding: utf-8
require 'rails_helper'
require 'support/feature_helper'
require 'support/shared/instance_thick_collate'

RSpec.feature 'User registration', js: true do
  include FeatureHelper

  describe 'new and edit' do
    context 'need login' do
      it 'should redirect to login page' do
        visit new_admin_instance_path
        expect(current_path).to eq(new_admin_user_session_path)
      end

      it 'should available after login' do
        admin_login
        visit new_admin_instance_path
        expect(current_path).to eq(new_admin_instance_path)
      end
    end

    context 'availabel fields' do
      before :each do
        admin_login
      end

      context 'new record' do

        it 'should need_database_create checked for new' do
          visit new_admin_instance_path
          expect(page.has_checked_field?(id: 'need_database_create')).to be(true)
        end

        it 'should field name available for new' do
          visit new_admin_instance_path
          expect(page.has_field?(id: 'instance_name')).to be(true)
        end
      end

      context 'persistent record' do
        include_context 'instance with content'

        it 'should need_database_create checked for new' do
          visit edit_admin_instance_path(id: instance.id)
          expect(page.has_checked_field?(id: 'need_database_create')).to be(false)
        end

        it 'should field name available for new' do
          visit edit_admin_instance_path(id: instance.id)
          expect(page.has_field?(id: 'instance_name')).to be(false)
        end
      end
    end
  end
end