#encoding: UTF-8
module ListPortHelper

  def user_port_retranslator(port)
    [
        content_tag(:div, I18n.t('forms.activeadmin.port.retranslator_on_port', port_to: Retranslator::port_to(port.number))),
        content_tag(:div) do
          concat('user: ')
          concat(content_tag(:i, Retranslator::user(port.number)))
        end,
        content_tag(:div, link_to('Выключить',
                                  retranslator_switch_off_url(Retranslator.all.active_by_replacement_port(port.number).first),
                                  data: {confirm: I18n.t('forms.activeadmin.confirm.retranslate_port_off', port: port.number)}))
    ].join.html_safe
  end

  def switch_on_retranslator(port)
    link_to(I18n.t('actions.port.retranslator'), retranslator_admin_program_port_path(program_id: port.program_id, id: port.id),
            method: :put, data: {confirm: I18n.t('forms.activeadmin.confirm.retranslate_port_sure', port: port.number)})
  end
end