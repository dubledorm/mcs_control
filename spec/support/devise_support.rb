require 'rails_helper'

module DeviseSupport
  def sign_in_as_admin
    @user ||= FactoryGirl.create :admin_user
    sign_in @user
  end

  def sign_in_as_manager
    @user ||= FactoryGirl.create :admin_user, admin: false
    sign_in @user
  end

  def sign_in_as_editor
    @user ||= FactoryGirl.create :admin_user, admin: false
    sign_in @user
  end
end