require 'database_name'

class OnlyOnePf2 < ActiveModel::Validator
  def validate(record)
    unless Program.pf2_only.count == 0
      record.errors[:base] << I18n.t('activerecord.errors.models.program.attributes.program_type.only_one_pf2')
    end
  end
end

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
  validates_with OnlyOnePf2, if: Proc.new{ |p| p.program_type == 'pf2'}

  scope :dcs_dev_only, ->{ where(program_type: 'dcs-dev') }
  scope :mc_only, ->{ where(program_type: 'mc') }
  scope :op_only, ->{ where(program_type: 'op') }
  scope :dcs_cli_only, ->{ where(program_type: 'dcs-cli') }
  scope :pf2_only, ->{ where(program_type: 'pf2') }
  scope :need_http_port, ->{ where(program_type: %w(mc op).freeze) }
  scope :need_tcp_port, ->{ where(program_type: 'dcs-dev') }
  scope :by_identification_name, ->(identification_name){ where(identification_name: identification_name) }

  def sym_program_type
    str_to_sym(program_type)
  end
end
