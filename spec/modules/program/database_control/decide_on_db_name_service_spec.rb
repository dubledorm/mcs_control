require 'rails_helper_without_transactions'

describe 'DecideOnDbNameService' do

  shared_examples 'database name eq' do
    context 'when database empty' do
      it { expect(Program::DatabaseControl::DecideOnDbNameService.new(program).call).to eq(coming_db_name) }
    end

    context 'when database name already exists' do
      it 'should increment name counter if same name already exists' do
        allow_any_instance_of(Program::DatabaseControl::DecideOnDbNameService).to receive(:get_database_list).
            and_return( [coming_db_name, "#{coming_db_name}_1"] )
        expect(Program::DatabaseControl::DecideOnDbNameService.new(program).call).to eq("#{coming_db_name}_2")
      end
    end
  end

  shared_examples 'database does not need' do
    it { expect{Program::DatabaseControl::DecideOnDbNameService.new(program).call}.to raise_error Program::DatabaseControl::DecideOnDbNameService::DoNotNeedDatabase}

    it 'test print' do
      begin
        Program::DatabaseControl::DecideOnDbNameService.new(program).call
      rescue Program::DatabaseControl::DecideOnDbNameService::DoNotNeedDatabase => e
        puts 'Отладочная печать:'
        puts e.message
      end
    end
  end


  describe 'database name' do
    let(:instance) { FactoryGirl.build :instance, name: 'chicken' }
    let(:super_instance) { FactoryGirl.build :instance, name: 'superchicken' }
    let(:foxy_instance) { FactoryGirl.build :instance, name: 'FoxyChicken' }


    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc' }
      let(:coming_db_name) { 'mc_chicken' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fnc',
                                        identification_name: 'chicken-mc-fnc' }
      let(:coming_db_name) { 'mc_chicken_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'op' }
      let(:coming_db_name) { 'op_chicken' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fnc' }
      let(:coming_db_name) { 'mc_chicken_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: super_instance, program_type: 'mc', additional_name: 'super-fnc' }
      let(:coming_db_name) { 'mc_superchicken_super_fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-cli' }
      let(:coming_db_name) { 'dcs4_chicken' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-cli', additional_name: 'fnc' }
      let(:coming_db_name) { 'dcs4_chicken_fnc' }
    end

    it_should_behave_like 'database does not need' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-dev' }
    end

    it_should_behave_like 'database does not need' do
      let(:program) { FactoryGirl.build :program, instance: instance, program_type: 'dcs-dev', additional_name: 'fnc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, instance: foxy_instance, program_type: 'mc', additional_name: 'Super-Fnc' }
      let(:coming_db_name) { 'mc_foxychicken_super_fnc' }
    end
  end
end
