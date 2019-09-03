module FeatureHelper
  def admin_login
    init_admin_defaults
    come_in(@admin)
  end

  def manager_login
    init_user_defaults
    come_in(@user)
  end

  def come_in(user)
    visit new_admin_user_session_path
    fill_in I18n.t('active_admin.devise.email.title'), with: user.email
    fill_in I18n.t('active_admin.devise.password.title'), with: user.password

    click_button I18n.t('active_admin.devise.login.submit')
  end

  def init_admin_defaults
    @admin ||= FactoryGirl.create(:admin_user, email: 'admin@example.com', password: 'password', admin: true)
  end

  def init_user_defaults
    @user ||= FactoryGirl.create(:admin_user, email: 'user@example.com', password: 'password', admin: false)
  end
end