class AddDbStatusToPort < ActiveRecord::Migration[6.0]
  def change
    add_column :ports, :db_status, :string
  end
end
