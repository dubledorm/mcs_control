class Port < ApplicationRecord
  include DualStorage
  include ApplicationHelper

  belongs_to :program
  has_one :instance, through: :program

  validates :number, :port_type, presence: true
  validates :number, uniqueness: true
  validates :port_type, format: { with: /\A(http|tcp)\z/}

  scope :http, ->{ where(port_type: 'http') }
  scope :tcp, ->{ where(port_type: 'tcp') }
  scope :port_type, -> (port_type){ where(port_type: port_type) }
  scope :port_number, -> (number){ where(number: number) }
  scope :instance, -> (instance_id){ joins(:program).where(programs: { instance_id: instance_id }) }
  scope :program_type, -> (program_type){ joins(:program).where(programs: { program_type: program_type } ) }


  # RANGE_OF_NUMBER = { http: { left_range: 30000, right_range: 31000 },
  #                     tcp: { left_range: 31001, right_range: 64000 }
  # }.freeze

  def sym_port_type
    str_to_sym(port_type)
  end
end
