ActiveAdmin.register Role do
  menu parent: :configure
  permit_params :name, :resource_type, :resource_id

  form do |f|
    f.inputs do
      f.input :name, as: :select, collection: Role::ROLE_NAMES.map { |role_name| [I18n.t("values.role.#{role_name}"), role_name] }
      f.input :resource_id, as: :select, collection: Instance.all.map { |instance| [instance.name, instance.id] }
      f.input :resource_type, input_html: { value: 'Instance' }, as: :hidden
      f.input :admin_user_id, input_html: { value: admin_user_id }, as: :hidden
    end
    f.actions
  end

  controller do
    include ApplicationHelper

    def new
      @admin_user_id = params.require(:admin_user_id)
      super
    end

    def destroy
      @page_title = I18n.t('forms.activeadmin.confirm.delete_role_page_title', role_name: resource.name)
      admin_user = AdminUser.find(params.require(:admin_user_id))
      instance = Instance.find(params.require(:instance_id))
      admin_user.remove_role params.require(:role_name), instance

      redirect_to admin_admin_user_path(admin_user)
    end

    def create
      @admin_user_id = params.require(:role).require(:admin_user_id)
      instance = Instance.find(params.require(:role).require(:resource_id))
      role_name = params.require(:role).require(:name)
      admin_user = AdminUser.find(@admin_user_id)
      admin_user.add_role role_name, instance

      redirect_to admin_admin_user_path(admin_user)
    end
  end
end
