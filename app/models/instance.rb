class Instance < ApplicationRecord
  include DualStorage

  has_many :ports
  has_many :programs
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :db_user_name, presence: true, format: { with: /\A[a-zA-Z_\d]+\z/}
end
