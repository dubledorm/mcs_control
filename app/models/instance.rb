class Instance < ApplicationRecord

  has_many :ports
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-z_\d]+\z/}
end
