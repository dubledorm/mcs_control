require 'rails_helper'

describe Program do

  describe 'standard call' do
    let!(:instance) {FactoryGirl.create :instance}

    it 'should not generate exception' do
      # noinspection SpellCheckingInspection
      expect{Program::CreateProgramInteractor.call(instance: instance, program_type: :mc)}.to_not raise_error
    end

    it 'should return success' do
      # noinspection SpellCheckingInspection
      expect(Program::CreateProgramInteractor.call(instance: instance, program_type: :mc).success?).to be(true)
    end

    # noinspection SpellCheckingInspection
    it { expect{Program::CreateProgramInteractor.call(instance: instance, program_type: :mc)}.to change(Program, :count).by(1) }
  end
end
