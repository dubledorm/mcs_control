ActiveAdmin.register Instance do
  includes :programs
  menu parent: :resources
  decorate_with InstanceDecorator
  config.filters = false

  permit_params :name, :description, :owner_name

  breadcrumb do
    breadcrumbs = [ link_to(I18n.t('words.admin'), admin_root_path())]
    breadcrumbs += [ link_to(I18n.t('activerecord.models.instance.other'),
                             admin_instances_path())] unless params[:action] == 'index'
    breadcrumbs
  end

  index do
    selectable_column
    id_column
    column :name
    column :state
    column :description
    column :owner_name
    column :collate_base_status
    column :created_at
    actions
  end


  show do
      attributes_table do
        row :name
        row :state
        row :description
        row :owner_name
        row :db_user_name
        row :db_user_password
        row :collate_base_status
      end


      panel Instance.human_attribute_name(:programs) do
        render 'admin/shared/programs_show', programs: instance.programs
      end
      active_admin_comments
  end


  form title: Instance.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.instance.attributes') do
      input :name unless resource.persisted?
      input :description
      input :owner_name
    end

    unless resource.persisted?
      inputs I18n.t('forms.activeadmin.instance.create_database_title') do
        render 'admin/shared/cb_and_label', variable_name: :need_database_create,
               variable_title: I18n.t('forms.activeadmin.instance.need_database_create'), checked: need_database_create || false
      end
    end
    actions
  end

  controller do
    include AdminInstance
  end


  action_item :check, only: :show do
    link_to I18n.t('actions.instance.check'), check_admin_instance_path(resource), method: :put if instance_can_collate_with_db?
  end

  action_item :add_program, only: :show do
    link_to I18n.t('actions.instance.add_program'), new_admin_instance_program_path(instance_id: resource) if instance_can_add_program?
  end

  action_item :update_nginx, only: :show do
    link_to I18n.t('actions.instance.update_nginx'), update_nginx_admin_instance_path(resource), method: :put if instance_can_update_nginx?
  end

  member_action :check, method: :put do
    begin
      test_point_exception
      Instance::DatabaseControl::CollateWithDbService.new(resource).call
      redirect_to admin_instance_path(resource), notice: "Checked!"
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_instance_path(resource), error: e.message
    end
  end

  member_action :update_nginx, method: :put do
    begin
      Instance::Nginx::ReloadService::new(resource).call
      resource.state = 'stable'
      resource.save!
      redirect_to admin_instance_path(resource), notice: "Updated!"
    rescue StandardError => e
      flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
      redirect_to admin_instance_path(resource), error: e.message
    end
  end
end
