ActiveAdmin.register Instance do
  includes :programs
  decorate_with InstanceDecorator

  permit_params :name, :description, :owner_name, :db_user_name, :db_user_password

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
    def new
      @need_database_create = true
      super
    end

    def create
      begin
        flash.delete(:alert)
        @need_database_create = params.try(:[], :need_database_create) || false
        @instance = Instance.new(params.require(:instance).permit(:name, :owner_name, :description))
        if params[:need_database_create].present?
          Instance::Factory::build_and_create_db(@instance)
        else
          Instance::Factory::build(@instance)
        end
        redirect_to admin_instance_path(id: @instance.id)
      rescue StandardError => e
        flash[:alert] = e.message
        render :new, alert: e.message
      end
    end

    def destroy
      @page_title = I18n.t('forms.activeadmin.confirm.delete_instance_page_title', instance_name: resource.name)
      begin
        if params[:confirm].present?
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
        redirect_to admin_instance_path(resource), alert: e.message
      end
    end
  end


  action_item :check, only: :show do
    link_to I18n.t('actions.instance.check'), check_admin_instance_path(resource), method: :put
  end

  member_action :check, method: :put do
    Instance::DatabaseControl::CollateWithDbService.new(resource).call
    redirect_to admin_instance_path(resource), notice: "Checked!"
  end
end
