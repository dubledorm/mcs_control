require 'rails_helper'

describe Program do

  shared_examples 'database name eq' do
    context 'empty database' do
      it { expect(Program::DecideOnDbNameService.new(program).call).to eq(coming_db_name) }
    end

    context 'database has two databases' do
      it 'should increment name counter if same name already exists' do
        allow_any_instance_of(Program::DecideOnDbNameService).to receive(:get_database_list).
            and_return( [coming_db_name, "#{coming_db_name}_1"] )
        expect(Program::DecideOnDbNameService.new(program).call).to eq("#{coming_db_name}_2")
      end
    end
  end

  shared_examples 'database does not need' do
    it { expect{Program::DecideOnDbNameService.new(program).call}.to raise_error Program::DecideOnDbNameService::DoNotNeedDatabase}
  end


  describe 'database name' do
    let(:instance) { FactoryGirl.build :instance, name: 'chicken' }
    let(:super_instance) { FactoryGirl.build :instance, name: 'super-chicken' }


    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc' }
      let(:coming_db_name) { 'chicken_mc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fnc',
                                        identification_name: 'chicken-mc-fnc' }
      let(:coming_db_name) { 'chicken_mc_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'op' }
      let(:coming_db_name) { 'chicken_op' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fnc' }
      let(:coming_db_name) { 'chicken_mc_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: super_instance, program_type: 'mc', additional_name: 'super-fnc' }
      let(:coming_db_name) { 'super_chicken_mc_super_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-cli' }
      let(:coming_db_name) { 'chicken_dcs4' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-cli', additional_name: 'fnc' }
      let(:coming_db_name) { 'chicken_dcs4_fnc' }
    end

    it_should_behave_like 'database does not need' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-dev' }
    end

    it_should_behave_like 'database does not need' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-dev', additional_name: 'fnc' }
    end
  end
end
