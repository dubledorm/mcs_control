class Port < ApplicationRecord
  include DualStorage

  belongs_to :instance
  belongs_to :program

  validates :number, :instance, :port_type, presence: true
  validates :number, uniqueness: true
  validates :port_type, format: { with: /\A(http|tcp)\z/}

end
