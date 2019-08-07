class AddDbStatusToProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :db_status, :string
  end
end
