#encoding: UTF-8
module ListPortHelper

  def show_retranslator_switcher(port)
    if (can?(:retranslator_on, Port) || can?(:retranslator_off, Port)) && port.program.can_retranslate_port?
      if Retranslator::is_active?(port.number)
         user_port_retranslator(port)
      else
        if Retranslator::has_free_port?
          switch_on_retranslator(port)
        else
          ''
        end
      end
    end
  end

  def user_port_retranslator(port)
    [
        content_tag(:div, I18n.t('forms.activeadmin.port.retranslator_on_port', port_to: Retranslator::port_to(port.number))),
        content_tag(:div) do
          concat('user: ')
          concat(content_tag(:i, Retranslator::user(port.number)))
        end,
        content_tag(:div, link_to('Выключить',
                                  retranslator_switch_off_url(Retranslator::find_by_replacement_port(port.number)),
                                  data: {confirm: I18n.t('forms.activeadmin.confirm.retranslate_port_off', port: port.number)}))
    ].join.html_safe
  end

  def switch_on_retranslator(port)
    link_to(I18n.t('actions.port.retranslator'), retranslator_on_admin_program_port_path(program_id: port.program_id, id: port.id),
            method: :put, data: {confirm: I18n.t('forms.activeadmin.confirm.retranslate_port_sure', port: port.number)})
  end

  def form_selected_field(label, name, values, width = 200)
    [
        content_tag(:div, class: 'gorizontal_field_group') do
          concat(label_tag(name, label, class: 'label'))
          concat(select_tag(name, options_for_select(values, params[name]), include_blank: true, style: "width:#{width}px"))
        end
    ].join.html_safe
  end

  def form_input_field(label, name, width = 200)
    [
        content_tag(:div, class: 'gorizontal_field_group') do
          concat(label_tag(name, label, class: 'label'))
          concat(text_field_tag(name, params[name], style: "width:#{width}px"))
        end
    ].join.html_safe
  end

end