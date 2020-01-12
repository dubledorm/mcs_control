require 'rails_helper_without_transactions'

RSpec.describe Program::Backup::CreateService do
  let!(:admin_user) { FactoryGirl::create :admin_user }

  context 'when database does not required' do
    let!(:program) { FactoryGirl::create :program, program_type: 'dcs-dev' }

    it { expect{ described_class.new(program, admin_user).call }.to raise_exception(Program::Backup::CreateService::NotDatabaseError) }
  end

  context 'when database require and exists' do
    before :each do
      @instance = Instance.new(name: 'testmilandrchicken')
      Instance::DatabaseControl::CreateUser.build(@instance)
      @instance.save
      @program = Program::Factory::build_and_create_db(@instance, 'mc', true, '')
    end

    it { expect{ described_class.new(@program, admin_user).call }.to_not raise_exception }
    it { expect( described_class.new(@program, admin_user).call.file.attached? ).to eq(true) }
  end

  context 'when database exists but has problem with user access' do
    before :each do
      @instance = Instance.new(name: 'testmilandrchicken')
      Instance::DatabaseControl::CreateUser.build(@instance)
      @instance.save
      @program = Program::Factory::build_and_create_db(@instance, 'mc', true, '')
    end

    it 'should generate exception' do
      allow_any_instance_of(Instance).to receive(:db_user_name).and_return('')
      expect{ described_class.new(@program, admin_user).call }.to raise_exception(Program::Backup::CreateService::RunBackupError)
    end
  end
end