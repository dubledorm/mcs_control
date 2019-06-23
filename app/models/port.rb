class Port < ApplicationRecord
  belongs_to :instance

  validates :number, :instance, presence: true
  validates :number, uniqueness: true
end
