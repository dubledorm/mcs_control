class CreateStoredFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :stored_files do |t|
      t.string   :description
      t.string   :filename,   null: false
      t.string   :content_type, null: false
      t.string   :state, null: false
      t.references :admin_user,     null: false
      t.references :program,     null: false
      t.timestamps

      t.index :state
      t.foreign_key :admin_users, column: :admin_user_id
      t.foreign_key :programs, column: :program_id
    end
  end
end
