class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.string :program_type, null: false
      t.string :name, null: false, uniq: true
      t.references :instance, null: false, foreign_key: true

      t.timestamps
    end

    add_index :programs, :program_type
    add_index :programs, :name
  end
end
