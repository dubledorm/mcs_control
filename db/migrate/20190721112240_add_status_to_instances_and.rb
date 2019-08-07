class AddStatusToInstancesAnd < ActiveRecord::Migration[6.0]
  def change
    change_column :instances, :db_user_name, :string, null: true
    add_column :instances, :state, :string
  end
end
