class Instance < ApplicationRecord
  include DualStorage

  has_many :programs, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z][a-zA-Z\d]+\z/}
  validates :db_user_name, format: { with: /\A[a-zA-Z][a-zA-Z_\d]+\z/}, allow_nil: true

  resourcify

  scope :available_user, ->(user_id){ joins(:roles).joins(:admin_user_roles).where(admin_user_role: { admin_user_id: user_id }) }
end
