class AddDbStatusToInstance < ActiveRecord::Migration[6.0]
  def change
    add_column :instances, :db_status, :string
  end
end
