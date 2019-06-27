require 'rails_helper'

describe Program do

  shared_examples 'database name eq' do
    it { expect(Program::DecideOnDbNameService.new(program).call).to eq(coming_db_name) }
  end


  describe 'empty database' do

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, identification_name: 'chicken-mc' }
      let(:coming_db_name) { 'chicken_mc' }
    end

    it_should_behave_like 'database name eq' do
      let(:program) { FactoryGirl.build :program, additional_name: 'fnc',
                                        identification_name: 'chicken-mc-fnc' }
      let(:coming_db_name) { 'chicken_mc_fnc' }
    end
  end


  describe 'database has two databases' do
    let(:program) { FactoryGirl.build :program, identification_name: 'chicken-mc' }

    it 'should increment name counter if same name already exists' do
      allow_any_instance_of(Program::DecideOnDbNameService).to receive(:get_database_list).and_return(%w(chicken_mc chicken_mc_1))
      expect(Program::DecideOnDbNameService.new(program).call).to eq('chicken_mc_2')
    end
  end
end
