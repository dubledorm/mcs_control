class ChangeColumnDbUsetNameInInstances < ActiveRecord::Migration[6.0]
  def up
    Instance.all.each do |instance|
      instance.db_user_name = 'user_name'
      instance.save
    end

    change_column :instances, :db_user_name, :string, null: false
  end
end
