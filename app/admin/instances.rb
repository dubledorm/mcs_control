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
 #    input :db_user_name
   end
   # panel 'Markup' do
   #  "The following can be used in the content below..."
   # end
   # inputs 'Content', :body
   para "Press cancel to return to the list without saving."
   actions
  end

  controller do

    def create
      instance = Instance::Factory::build(params[:instance][:name])
      instance.description = params[:instance][:description]
      instance.owner_name = params[:instance][:owner_name]
      if instance.save
        redirect_to admin_instance_path(id: instance.id)
      else
        render :new
      end
    end
  end
end
