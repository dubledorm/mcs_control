#coding: utf-8
require 'rails_helper_without_transactions'

RSpec.feature 'User registration', js: true do

  describe '#new_admin_user_session' do
    let!(:user) { FactoryGirl.create(:admin_user, email: 'admin@example.com', password: 'password') }

    before :each do
      visit new_admin_user_session_path
    end

    context 'when login is true' do
      # Проверяем что входим при правильном логин
      it "should redirect to admin_root_path" do
        fill_in I18n.t('active_admin.devise.email.title'), with: "admin@example.com"
        fill_in I18n.t('active_admin.devise.password.title'), with: "password"

        click_button I18n.t('active_admin.devise.login.submit')

        expect(current_path).to eq(admin_root_path)
      end
    end

    context 'when login is wrong' do
      # Проверяем, что остаёмся на форме регистрации при не правильном пароле
      it "should stand still" do
        fill_in I18n.t('active_admin.devise.email.title'), with: "admin1111@example.com"
        fill_in I18n.t('active_admin.devise.password.title'), with: "password"

        click_button I18n.t('active_admin.devise.login.submit')
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end
  end
end
