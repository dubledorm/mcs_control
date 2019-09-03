ActiveAdmin.register Instance do
  includes :programs
  decorate_with InstanceDecorator

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
    column :description
    column :owner_name
    column :collate_base_status
    column :created_at
    actions
  end


  show do
      attributes_table do
        row :name
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
    include ApplicationHelper

    def scoped_collection
      if current_admin_user.admin?
        Instance.all
      else
        Instance.with_role(Role::ROLE_NAMES, current_admin_user)
      end
    end

    def new
      @need_database_create = true
      super
    end


    def create
      @need_database_create = str_to_bool(params.try(:[], :need_database_create))
      flash.delete(:error)
      create! { |success, failure|
        success.html do
          begin
            if @need_database_create
              Instance::Factory::build_and_create_db(resource)
            else
              Instance::Factory::build(resource)
            end
            test_point_exception
            redirect_to admin_instance_path(id: resource.id),
                        notice: I18n.t('forms.activeadmin.instance.created_succesfully')
          rescue StandardError => e
            Instance::Destructor::destroy_and_drop_db(resource) if resource.persisted?
            flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
            render :new, error: e.message
          end
        end
        failure.html do
          flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: resource.errors.full_messages.join(','))
          render :new
        end
      }
    end

    def destroy
      @page_title = I18n.t('forms.activeadmin.confirm.delete_instance_page_title', instance_name: resource.name)
      flash.delete(:error)
      begin
        if params[:confirm].present?
          test_point_exception
          Instance::Destructor::destroy_and_drop_db(resource)
          redirect_to admin_instances_path
        else
          render 'admin/shared/destroy_confirm', layout: 'active_admin',
                 locals: {title: I18n.t('forms.activeadmin.confirm.delete_instance_message'),
                          back_path: admin_instance_path(resource),
                          delete_path: admin_instance_path(resource, confirm: true)
                 }
        end
      rescue StandardError => e
        flash[:error] = I18n.t('activerecord.errors.messages.unknown_resource_exception', errors: e.message)
        redirect_to admin_instance_path(resource), error: e.message
      end
    end
  end


  action_item :check, only: :show do
    link_to I18n.t('actions.instance.check'), check_admin_instance_path(resource), method: :put
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
end
