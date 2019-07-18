#coding: utf-8
require 'rails_helper'

RSpec.feature 'User registration', js: true do
  context "login admin user" do
    let!(:user) { FactoryGirl.create(:admin_user, email: 'admin@example.com', password: 'password') }

    before :each do
      visit new_admin_user_session_path
    end

    # Проверяем что входим при правильном логин
    it "lets the user log in" do
      fill_in I18n.t('active_admin.devise.email.title'), with: "admin@example.com"
      fill_in I18n.t('active_admin.devise.password.title'), with: "password"

      click_button I18n.t('active_admin.devise.login.submit')

      expect(current_path).to eq(admin_root_path)
    end

    # Проверяем, что остаёмся на форме регистрации при не правильном пароле
    it "lets the wrong user log in" do
      fill_in I18n.t('active_admin.devise.email.title'), with: "admin1111@example.com"
      fill_in I18n.t('active_admin.devise.password.title'), with: "password"

      click_button I18n.t('active_admin.devise.login.submit')
      expect(current_path).to eq(new_admin_user_session_path)
    end
  end
end
