class Program < ApplicationRecord
  belongs_to :instance

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :program_type, presence: true
end
