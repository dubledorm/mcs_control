class AddAdminToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :admin, :boolean, default: false

    admin_user = AdminUser.where(email: 'admin@example.com').first
    admin_user.admin = true
    admin_user.save
  end
end
