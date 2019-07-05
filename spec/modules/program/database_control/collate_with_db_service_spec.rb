require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Program::DatabaseControl::CollateWithDbService do
  include DatabaseTools
  describe 'only_here_exists' do
    include_context 'instance with content'

    # before :each do
    #   config   = Rails.configuration.database_configuration
    #   program_op.database_name = 'op_infosphera_test'
    #   instance.db_user_name = config[Rails.env]["admin_username"]
    #   instance.db_user_password = config[Rails.env]["admin_password"]
    #
    #   Program::DatabaseControl::CollateWithDbService.new(program_op).call
    #   program_op.reload
    # end
    #
    # it {expect(program_op.ports.count).to eq(1)}
  end
end
