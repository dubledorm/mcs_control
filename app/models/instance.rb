class Instance < ApplicationRecord

  has_many :ports
  has_many :programs
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :db_user_name, presence: true
end
