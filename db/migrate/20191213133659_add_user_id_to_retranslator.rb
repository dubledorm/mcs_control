class AddUserIdToRetranslator < ActiveRecord::Migration[6.0]
  def change
    add_reference :retranslators, :admin_user, index: true
  end
end
