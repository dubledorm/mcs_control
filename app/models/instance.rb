class Instance < ApplicationRecord

  has_many :ports
  has_many :programs
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z_\d]+\z/}
end
