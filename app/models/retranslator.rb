
class Retranslator < ApplicationRecord

  validates :port_from, :port_to, presence: true

  def self.active?
    retranslator = Retranslator.first
    return false unless retranslator
    retranslator.active
  end

  def self.retranslator_port
    retranslator = Retranslator.first
    return nil unless retranslator
    retranslator.port_from
  end

  def self.retranslator_replacement_port
    retranslator = Retranslator.first
    return nil unless retranslator
    return nil unless retranslator.active?
    retranslator.replacement_port
  end
end