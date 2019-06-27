require 'rails_helper'

describe Program do

  describe 'decide_on_db_name_service' do
    let(:program) { FactoryGirl.build :program, identification_name: 'chicken-mc' }

    it 'should return name if the db does not exists' do
      expect(Program::DecideOnDbNameService.new(program).call).to eq('chicken_mc')
    end

    it 'should increment name counter if same name already exists' do
      # noinspection RubyArgCount
      Program::DecideOnDbNameService.any_instance.stub(:get_database_list).
          and_return(%w(chicken_mc chicken_mc_1))
      expect(Program::DecideOnDbNameService.new(program).call).to eq('chicken_mc_2')
    end
  end
end
