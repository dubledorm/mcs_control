ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row :email
      row :created_at
      row :updated_at
    end

    panel AdminUser.human_attribute_name(:roles) do
      render 'admin/admin_user/roles_show', roles: admin_user.roles.instances_only, user: admin_user
    end
    active_admin_comments
  end


  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  action_item :add_role, only: :show do
    link_to I18n.t('actions.admin_user.add_role'), new_admin_role_path(admin_user_id: resource.id)
  end
end
