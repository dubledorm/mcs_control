class AddStateToPrograms < ActiveRecord::Migration[6.0]
  def change
    add_column :programs, :state, :string
  end
end
