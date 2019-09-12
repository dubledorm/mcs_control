class Instance
  module Export
    class NginxHttpService

      def initialize(instance)
        @instance = instance
      end

      def call
        result = []
        @instance.programs.each do |program|
          result += Program::Export::NginxHttpService::new(program).call
        end
        result
      end

      private
        attr_accessor :instance
    end
  end
end
