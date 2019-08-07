module FeatureHelper
  def admin_login
    init_admin_defaults
    visit new_admin_user_session_path
    fill_in I18n.t('active_admin.devise.email.title'), with: @admin.email
    fill_in I18n.t('active_admin.devise.password.title'), with: @admin.password

    click_button I18n.t('active_admin.devise.login.submit')
  end

  def init_admin_defaults
    @admin ||= FactoryGirl.create(:admin_user, email: 'admin@example.com', password: 'password')
  end
end