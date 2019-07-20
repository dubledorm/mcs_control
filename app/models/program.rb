require 'database_name'

class Program < ApplicationRecord
  include DualStorage
  include ApplicationHelper

  belongs_to :instance
  has_many :ports, dependent: :destroy

  validates :database_name, uniqueness: true, allow_nil: true, format: { with: /\A[a-zA-Z][a-zA-Z_\d]+\z/}
  validates :identification_name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :additional_name, format: { with: /\A([a-zA-Z\-\d]+)??\z/}, allow_nil: true
  validates :program_type, presence: true, inclusion: { in: %w(mc op dcs-dev dcs-cli) }
  validates :instance, presence: true

  def sym_program_type
    str_to_sym(program_type)
  end
end
