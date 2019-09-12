class Port < ApplicationRecord
  include DualStorage
  include ApplicationHelper

  belongs_to :program

  validates :number, :port_type, presence: true
  validates :number, uniqueness: true
  validates :port_type, format: { with: /\A(http|tcp)\z/}

  scope :http, ->{ where(port_type: 'http') }
  scope :tcp, ->{ where(port_type: 'tcp') }


  def sym_port_type
    str_to_sym(port_type)
  end
end
