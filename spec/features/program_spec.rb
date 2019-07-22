#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature 'Program', js: true do
  include FeatureHelper
  include DatabaseTools

  before :each do
    @instance = Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
    @program = @instance.programs.first
  end

  context 'when not login' do
    it 'should redirect to login page' do
      visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
      expect(current_path).to eq(new_admin_user_session_path)
    end
  end

  context 'when login' do
    before :each do
      admin_login
    end

    describe '#destroy' do
      context 'when all ok' do
        before :each do
          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
          click_link 'Удалить Программа'
          sleep(3)
          click_link 'Удалить'
          sleep(3)
        end

        it 'should redirect to admin_instance_path' do
          expect(current_path).to eq(admin_instance_path(id: @instance.id))
        end

        it 'should decrement programs.count' do
          expect(@instance.programs.count).to eq(3)
        end
      end

      context 'when exception call during destroy' do
        before :each do
          allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )

          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
          click_link 'Удалить Программа'
          sleep(3)
          click_link 'Удалить'
          sleep(3)
        end

        it 'should redirect to admin_instance_path' do
          expect(current_path).to eq(admin_instance_path(id: @instance.id))
        end

        it 'should has error message' do
          expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
        end
      end
    end

    describe '#show' do
      it 'should has page_title' do
        visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
        expect(page.has_css?('h2#page_title', text: @program.identification_name)).to be(true)
      end
    end
  end
end
