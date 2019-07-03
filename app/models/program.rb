class Program < ApplicationRecord
  include DualStorage

  belongs_to :instance
  has_many :ports

  validates :database_name, uniqueness: true, allow_nil: true
  validates :identification_name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\-\d]+\z/}
  validates :additional_name, format: { with: /\A([a-zA-Z\-\d]+)??\z/}, allow_nil: true
  validates :program_type, presence: true, inclusion: { in: %w(mc op dcs-dev dcs-cli) }
  validates :instance, presence: true

  def set_identification_name
    self.identification_name = "#{ instance.name }-#{ program_type.to_s }#{ additional_name.blank? ? '' : '-' + additional_name }"
  end

  def sym_program_type
    program_type.parameterize.underscore.to_sym
  end
end
