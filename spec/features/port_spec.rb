#coding: utf-8
require 'rails_helper_without_transactions'
require 'support/feature_helper'
require 'database_tools'

RSpec.feature 'Port', js: true do
  include FeatureHelper
  include DatabaseTools

  before :each do
    @instance = Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
    @program = @instance.programs.dcs_dev_only.first
    @port = @program.ports.first
  end

  context 'when not login' do
    it 'should redirect to login page' do
      visit admin_program_port_path(program_id: @program.id, id: @port.id)
      expect(current_path).to eq(new_admin_user_session_path)
    end
  end

  context 'when login' do
    before :each do
      admin_login
    end

    it { expect(@program.ports.count).to eq(1) }

    describe '#create' do
      context 'when all ok' do
        before :each do
          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          click_link 'Добавить порт'
          sleep(3)
          click_button value: 'Create Порт'
          sleep(3)
        end

        it 'should redirect to admin_instance_program_path' do
          expect(current_path).to eq(admin_instance_program_path(instance_id: @instance.id, id: @program.id))
        end

        it 'should increment ports.count' do
          expect(@program.ports.count).to eq(2)
        end
      end

      context 'when exception call during create' do
        before :each do
          allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )

          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          click_link 'Добавить порт'
          sleep(3)
          click_button value: 'Create Порт'
          sleep(3)
        end

        it 'should redirect to new_admin_program_port_path' do
          expect(current_path).to eq(new_admin_program_port_path(program_id: @program.id))
        end

        it 'should has error message' do
          expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
        end
      end
    end

    describe '#destroy' do

      context 'when all ok' do
        before :each do
          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
          click_link 'Удалить', href: admin_program_port_path(program_id: @program.id, id: @port.id)
          sleep(3)
          click_link 'Удалить'
          sleep(3)
        end

        it 'should redirect to admin_instance_program_path' do
          expect(current_path).to eq(admin_instance_program_path(instance_id: @instance.id, id: @program.id))
        end

        it 'should decrement port.count' do
          expect(@program.ports.count).to eq(0)
        end
      end

      context 'when exception call during destroy' do
        before :each do
          allow_any_instance_of(ApplicationHelper).to receive(:test_point_exception_enable?).and_return( true )

          visit admin_instance_program_path(instance_id: @instance.id, id: @program.id)
          page.evaluate_script('window.confirm = function() { return true; }') # Убирает confirm диалог
          click_link 'Удалить', href: admin_program_port_path(program_id: @program.id, id: @port.id)
          sleep(3)
          click_link 'Удалить'
          sleep(3)
        end

        it 'should redirect to admin_instance_program_path' do
          expect(current_path).to eq(admin_instance_program_path(instance_id: @instance.id, id: @program.id))
        end

        it 'should has error message' do
          expect(page.has_css?('.flash.flash_error', text: I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: 'Test exception message'))).to be(true)
        end
      end
    end
  end
end
