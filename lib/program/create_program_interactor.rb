class Program
  # noinspection SpellCheckingInspection
  class CreateProgramInteractor
    include Interactor

    def call
      begin
        program = Program.new(instance: context.instance,
                              additional_name: context.additional_name,
                              program_type: context.program_type)

        program.set_identification_name
        program.database_name = Program::DecideOnDbNameService.new(program).call
        program.save

        context.program = program
      rescue
        context.fail!(message: 'CreateProgramInteractor.call failed')
      end
    end
  end
end
