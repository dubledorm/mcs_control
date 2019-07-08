ActiveAdmin.register Instance do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
 permit_params :name, :description, :owner_name, :db_user_name, :db_user_password
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


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
