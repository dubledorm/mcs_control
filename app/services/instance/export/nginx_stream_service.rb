class Instance
  module Export
    class NginxStreamService

      def initialize(instance)
        @instance = instance
      end

      def call
        result = []
        @instance.programs.each do |program|
          result += Program::Export::NginxStreamService::new(program).call
        end
        result
      end
    end
  end
end
