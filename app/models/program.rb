require 'database_name'

class Program < ApplicationRecord
  include DualStorage
  include ProgramToolBox
  include ApplicationHelper

  belongs_to :instance
  has_many :ports, dependent: :destroy

  validates :database_name, uniqueness: true, allow_nil: true, format: { with: /\A[a-zA-Z][a-zA-Z_\d]+\z/}
  validates :identification_name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :additional_name, format: { with: /\A([a-zA-Z\-\d]+)??\z/}, allow_nil: true
  validates :program_type, presence: true, inclusion: { in: KNOWN_PROGRAM_TYPES.keys }
  validates :instance, presence: true

  scope :dcs_dev_only, ->{ where(program_type: 'dcs-dev') }
  scope :mc_only, ->{ where(program_type: 'mc') }
  scope :op_only, ->{ where(program_type: 'op') }
  scope :dcs_cli_only, ->{ where(program_type: 'dcs-cli') }
  scope :need_http_port, ->{ where(program_type: %w(mc op).freeze) }
  scope :need_tcp_port, ->{ where(program_type: 'dcs-dev') }

  def sym_program_type
    str_to_sym(program_type)
  end
end
