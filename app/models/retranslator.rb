
class Retranslator < ApplicationRecord
  include RetranslatorToolBox

  validates :port_from, :port_to, presence: true, uniqueness: true

  belongs_to :admin_user, optional: true

  scope :by_replacement_port, ->(replacement_port){ where(replacement_port: replacement_port) }
  scope :active_by_replacement_port, ->(replacement_port){ where(replacement_port: replacement_port, active: true) }
  scope :active_by_port_to, ->(port_to){ where(port_to: port_to, active: true) }
  scope :active_by_port_from, ->(port_from){ where(port_from: port_from, active: true) }
  scope :passive, ->{ where(active: [false, nil]) }

  scope :by_channel, ->(channel_name){ where( port_from: channel_name_port_from(channel_name),
                                              port_to: channel_name_port_to(channel_name)) }
end