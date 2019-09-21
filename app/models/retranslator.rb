
class Retranslator < ApplicationRecord

  validates :port_from, :port_to, presence: true

end