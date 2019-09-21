class AddCreateDbMySelfToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :created_db_myself, :boolean, default: false
  end
end
