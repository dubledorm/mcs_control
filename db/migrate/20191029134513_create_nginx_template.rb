class CreateNginxTemplate < ActiveRecord::Migration[6.0]
  def change
    create_table :nginx_templates do |t|
      t.string :program_type, null: false, uniq: true
      t.text :content_http
      t.text :content_tcp
      t.boolean :use_for_http
      t.boolean :use_for_tcp
      t.text :description

      t.timestamps
    end
  end
end
