RSpec.shared_context 'instance with content' do
  let!(:instance) {FactoryGirl.create :instance, name: 'test-milandr-chicken', db_user_name: 'test_milandr_chicken', db_status: 'undefined'}
  let!(:program_mc) {FactoryGirl.create :program, instance: instance, program_type: 'mc', database_name: 'test_milandr_chicken_mc',
                                        identification_name: 'test-milandr-chicken-mc', db_status: 'undefined'}
  let!(:program_op) {FactoryGirl.create :program, instance: instance, program_type: 'op', database_name: 'test_milandr_chicken_op',
                                        identification_name: 'test-milandr-chicken-op', db_status: 'undefined'}
  let!(:program_cli) {FactoryGirl.create :program, instance: instance, program_type: 'dcs-cli', database_name: 'test_milandr_chicken_dcs4',
                                         identification_name: 'test-milandr-chicken-dcs-cli', db_status: 'undefined'}
  let!(:program_dev) {FactoryGirl.create :program, instance: instance, program_type: 'dcs-dev',
                                         identification_name: 'test-milandr-chicken-dcs-dev', db_status: 'undefined'}
end
