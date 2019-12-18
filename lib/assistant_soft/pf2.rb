module AssistantSoft
  class Pf2 < BaseRetranslator
    def find_program
      program = Program.pf2_only.first
      raise StandardError, 'Program Pf2 does not find' unless program
      program
    end
  end
end
