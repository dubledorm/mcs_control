class Program < ApplicationRecord
  belongs_to :instance
  has_many :ports

  validates :database_name, presence: true, uniqueness: true
  validates :identification_name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :additional_name, format: { with: /\A([a-zA-Z\-\d]+)??\z/}, allow_nil: true
  validates :program_type, presence: true, inclusion: { in: %w(mc op dcs-dev dcs-cli) }
end
