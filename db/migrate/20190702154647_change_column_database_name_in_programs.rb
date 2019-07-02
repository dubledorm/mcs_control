class ChangeColumnDatabaseNameInPrograms < ActiveRecord::Migration[6.0]
  def up
    change_column :programs, :database_name, :string, null: true, uniq: true
  end

  def down
    change_column :programs, :database_name, :string, null: false, uniq: true
  end
end
