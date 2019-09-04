# noinspection SpellCheckingInspection
class AdminUser < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable


  has_many :instances, through: :roles, source: :resource, source_type: 'Instance'
  has_many :programs, through: :instances
  has_many :ports, through: :programs
  has_many :admin_users, through: :roles, source: :resource, source_type: 'AdminUser'
end
