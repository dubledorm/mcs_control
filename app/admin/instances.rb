ActiveAdmin.register Instance do
  includes :programs

  permit_params :name, :description, :owner_name, :db_user_name, :db_user_password

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :owner_name
    column :db_status do |instance|
      instance.decorate.collate_base_status
    end
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
        row :db_status do |instance|
          instance.decorate.collate_base_status
        end
      end


      panel Instance.human_attribute_name(:programs) do
        render 'admin/shared/program_show', programs: instance.programs
      end
      active_admin_comments
  end


  form title: Instance.model_name.human do |f|
   inputs 'Details' do
     input :name
     input :description
     input :owner_name
    end
   actions
  end

  controller do

    def create
      begin
        @instance = Instance.new(params.require(:instance).permit(:name, :owner_name, :description))
        Instance::Factory::build_and_create_db(@instance)
        redirect_to admin_instance_path(id: @instance.id)
      rescue StandardError => e
        render :new, alert: e.message
      end
    end
  end
end
