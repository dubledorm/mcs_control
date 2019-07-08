require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Instance::DatabaseControl::CollateWithDbService do
  include DatabaseTools
  describe 'only_here_exists' do
    include_context 'instance with content'

    before :each do
      Instance::DatabaseControl::CollateWithDbService.new(instance).call
      program_mc.reload
      program_op.reload
      program_cli.reload
      program_dev.reload
    end

    it {expect(program_mc.sym_db_status).to eq(:only_here_exists)}
    it {expect(program_op.sym_db_status).to eq(:only_here_exists)}
    it {expect(program_cli.sym_db_status).to eq(:only_here_exists)}
    it {expect(program_dev.sym_db_status).to eq(:only_here_exists)}
  end

  describe 'everywhere_exists' do
    include_context 'instance with content'

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )

      Instance::DatabaseControl::CollateWithDbService.new(instance).call
      program_mc.reload
      program_op.reload
      program_cli.reload
      program_dev.reload
    end

    it {expect(program_mc.sym_db_status).to eq(:everywhere_exists)}
    it {expect(program_op.sym_db_status).to eq(:everywhere_exists)}
    it {expect(program_cli.sym_db_status).to eq(:everywhere_exists)}
    it {expect(program_dev.sym_db_status).to eq(:only_here_exists)}
  end

  describe 'only_there_exists' do
    let!(:instance) {FactoryGirl.create :instance, name: 'testmilandrchicken', db_user_name: 'testmilandrchicken', db_status: 'undefined'}

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )

      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    it { expect(instance.programs.count).to eq(3) }
    it { expect(instance.programs[0].sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs[1].sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs[2].sym_db_status).to eq(:only_there_exists) }
  end
end
