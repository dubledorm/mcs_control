class Port < ApplicationRecord
  include DualStorage
  include ApplicationHelper

  belongs_to :program

  validates :number, :port_type, presence: true
  validates :number, uniqueness: true
  validates :port_type, format: { with: /\A(http|tcp)\z/}

  def sym_port_type
    str_to_sym(port_type)
  end
end
