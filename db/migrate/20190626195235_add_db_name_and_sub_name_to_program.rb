class AddDbNameAndSubNameToProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :database_name, :string, null: false, uniq: true
    add_column :programs, :additional_name, :string
    remove_column :programs, :name, :string
  end
end
