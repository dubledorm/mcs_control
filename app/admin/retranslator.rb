# encoding: UTF-8
ActiveAdmin.register Retranslator do
  permit_params :port_from, :port_to
  config.filters = false

  breadcrumb do
    breadcrumbs = [ link_to(I18n.t('words.admin'), admin_root_path()) ]
    breadcrumbs += [ link_to(I18n.t('activerecord.models.retranslator.other'),
                             admin_retranslators_path())] unless params[:action] == 'index'
    breadcrumbs
  end


  form title: Retranslator.model_name.human do |f|
    f.semantic_errors *f.object.errors.keys
    inputs I18n.t('forms.activeadmin.retranslator.attributes') do
      input :port_from
      input :port_to
    end

    actions
  end
end