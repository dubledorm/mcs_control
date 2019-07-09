class Instance
  class Destructor

    def self.destroy_and_drop_db(instance)
      instance.programs.each do |program|
        Program::Destructor::destroy_and_drop_db(program)
        program.destroy
      end
    end
  end
end
