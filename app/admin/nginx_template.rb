# encoding: UTF-8
ActiveAdmin.register NginxTemplate do
  scope_to :current_admin_user, unless: proc{ current_admin_user.admin? }
  permit_params :program_type, :content_tcp, :content_http, :use_for_tcp, :use_for_http, :description,
                :instance_id, :for_instance_only
  decorate_with NginxTemplateDecorator
  config.filters = false

  breadcrumb do
    [ link_to(I18n.t('words.admin'), admin_root_path()) ]
  end


  form title: NginxTemplate.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.program.attributes') do
      input :program_type, as: :select, collection: options_for_select(program_types_with_translate, resource.program_type),
            label: NginxTemplate.human_attribute_name(:program_type)
      input :instance
      input :for_instance_only
      input :content_http
      input :use_for_http
      input :content_tcp 
      input :use_for_tcp

      input :description
    end

   actions
  end
end