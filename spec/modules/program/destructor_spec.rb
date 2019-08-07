require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Program::Destructor do
  include DatabaseTools
  include_context 'instance with content'

  context 'when all databases exist' do

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
      create_user(ActiveRecord::Base.connection, 'testmilandrchicken')

      @program_tmp =  Program::Factory::build_and_create_db(instance, 'mc', 'temp')
    end

    it {expect(Program.count).to eq(5)}

    it {expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken_temp')).to be(true)}

    it 'should decrement Program.count' do
      expect{Program::Destructor::destroy_and_drop_db(@program_tmp)}.to change(Program, :count).by(-1)
    end

    it 'should drop database mc_testmilandrchicken_temp' do
      Program::Destructor::destroy_and_drop_db(@program_tmp)
      expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken_temp')).to be(false)
    end

    it 'database does not exists' do
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken_temp' )
      expect{Program::Destructor::destroy_and_drop_db(@program_tmp)}.to change(Program, :count).by(-1)
    end
  end
end