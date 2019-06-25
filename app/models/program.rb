class Program < ApplicationRecord
  belongs_to :instance
  has_many :ports

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :program_type, presence: true, inclusion: { in: %w(mc op dcs-dev dcs-cli) }
end
