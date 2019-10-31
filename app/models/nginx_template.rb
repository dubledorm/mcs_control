class NginxTemplate < ApplicationRecord
  include ProgramToolBox

  validates :program_type, presence: true, uniqueness: true, inclusion: { in: KNOWN_PROGRAM_TYPES.keys }

  scope :by_http_and_program_type, ->(program_type){ where(program_type: program_type, use_for_http: true) }
  scope :by_tcp_and_program_type, ->(program_type){ where(program_type: program_type, use_for_tcp: true) }

  def self.get_by_http_and_program_type(program_type)
    template = NginxTemplate.by_http_and_program_type(program_type).first
    return nil if template.blank?
    template.content_http
  end

  def self.get_by_tcp_and_program_type(program_type)
    template = NginxTemplate.by_tcp_and_program_type(program_type).first
    return nil if template.blank?
    template.content_tcp
  end
end
