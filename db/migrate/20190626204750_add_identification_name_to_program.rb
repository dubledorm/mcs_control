class AddIdentificationNameToProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :identification_name, :string, presence: true, unique: true

    add_index :programs, :identification_name, unique: true
  end
end
