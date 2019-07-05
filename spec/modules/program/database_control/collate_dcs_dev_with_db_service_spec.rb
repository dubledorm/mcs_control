require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Program::DatabaseControl::CollateDcsDevWithDbService do
  include DatabaseTools
  describe 'only_here_exists' do
    include_context 'instance with content'

    before :each do
      config   = Rails.configuration.database_configuration
      program_op.database_name = 'op_infosphera_test'
      instance.db_user_name = config[Rails.env]["admin_username"]
      instance.db_user_password = config[Rails.env]["admin_password"]
      program_op.save!

      Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call
      program_dev.reload
    end

    it {expect(program_dev.ports.count).to eq(1)}

  end


  describe 'exception' do
    include_context 'instance with content'

    describe 'only dcs dev' do
      before :each do
        config   = Rails.configuration.database_configuration
        program_op.database_name = 'op_infosphera_test'
        instance.db_user_name = config[Rails.env]["admin_username"]
        instance.db_user_password = config[Rails.env]["admin_password"]
        program_op.save!
      end

      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_cli).call}.to raise_error ArgumentError}
    end


    describe 'not found op' do
      include_context 'instance with content'

      it {expect{Program::DatabaseControl::CollateDcsDevWithDbService.new(program_dev).call}.to raise_error StandardError}
    end
  end
end
