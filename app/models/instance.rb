class Instance < ApplicationRecord
  include DualStorage

  has_many :ports, dependent: :destroy
  has_many :programs, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z][a-zA-Z\d]+\z/}
  validates :db_user_name, presence: true, format: { with: /\A[a-zA-Z][a-zA-Z_\d]+\z/}
end
