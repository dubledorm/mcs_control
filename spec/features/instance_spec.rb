#coding: utf-8
require 'rails_helper'
require 'support/feature_helper'
require 'support/shared/instance_thick_collate'

RSpec.feature 'Instance', js: true do
  include FeatureHelper

  describe '#new' do
    context 'when not login' do
      it 'should redirect to login page' do
        visit new_admin_instance_path
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'when login' do
      before :each do
        admin_login
      end

      it 'should available new_admin_instance_path' do
        visit new_admin_instance_path
        expect(current_path).to eq(new_admin_instance_path)
      end

      context 'when new record' do
        it 'should need_database_create checked for new' do
          visit new_admin_instance_path
          expect(page.has_checked_field?(id: 'need_database_create')).to be(true)
        end

        it 'should field name available for new' do
          visit new_admin_instance_path
          expect(page.has_field?(id: 'instance_name')).to be(true)
        end
      end
    end
  end

  describe '#edit' do
    include_context 'instance with content'

    context 'when not login' do
      it 'should redirect to login page' do
        visit edit_admin_instance_path(id: instance.id)
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'when login' do
      before :each do
        admin_login
        visit edit_admin_instance_path(id: instance.id)
      end

      it 'need_database_create should not available' do
        expect(page.has_checked_field?(id: 'need_database_create')).to be(false)
      end

      it 'field name should not available' do
        expect(page.has_field?(id: 'instance_name')).to be(false)
      end
    end
  end
end