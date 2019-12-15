module PortHelper

  def retranslator_port(port)
    [
        content_tag(:div, Retranslator::port_to(port&.number)&.to_s),
        content_tag(:div, class: :message_text) do
          concat(content_tag(:i, I18n.t('messages.retranslator_port')))
        end
    ].join.html_safe
  end
end