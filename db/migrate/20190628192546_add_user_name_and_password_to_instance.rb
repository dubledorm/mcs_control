class AddUserNameAndPasswordToInstance < ActiveRecord::Migration[6.0]
  def change
    add_column :instances, :db_user_name, :string
    add_column :instances, :db_user_password, :string
  end
end
