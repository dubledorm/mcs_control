class Instance < ApplicationRecord
  include DualStorage

  has_many :ports
  has_many :programs
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :db_user_name, presence: true

  def database_prefix
    name.gsub('-', '_')
  end
end
