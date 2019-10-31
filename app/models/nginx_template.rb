class NginxTemplate < ApplicationRecord
  include ProgramToolBox

  belongs_to :instance, optional: true
  validates :program_type, presence: true,
            uniqueness: { scope: :instance },
            inclusion: { in: KNOWN_PROGRAM_TYPES.keys }

  validates :instance, presence: true, if: Proc.new { |a| a.for_instance_only?}


  scope :by_http_and_program_type, ->(program_type){ where(program_type: program_type, use_for_http: true) }
  scope :by_tcp_and_program_type, ->(program_type){ where(program_type: program_type, use_for_tcp: true) }

  def self.get_by_http_and_program_type(program)
    templates = NginxTemplate.by_http_and_program_type(program.program_type)

    result = find_template_for_program(templates, program)
    return nil if result.blank?
    result.content_http
  end

  def self.get_by_tcp_and_program_type(program)
    templates = NginxTemplate.by_tcp_and_program_type(program.program_type)

    result = find_template_for_program(templates, program)
    return nil if result.blank?
    result.content_tcp
  end

  private

    def self.find_template_for_program(templates, program)
      result = templates.find_all{ |template| template.for_instance_only? && template.instance == program.instance}.first
      return result unless result.nil?

      result = templates.find_all{ |template| !template.for_instance_only?}.first
      return nil if result.nil?
      result
    end
end
