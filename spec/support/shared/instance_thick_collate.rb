RSpec.shared_context 'instance with content' do
  let!(:instance) {FactoryGirl.create :instance, name: 'testmilandrchicken', db_user_name: 'test_milandr_chicken', db_status: 'undefined'}
  let!(:program_mc) {FactoryGirl.create :program, instance: instance, program_type: 'mc', database_name: 'mc_testmilandrchicken',
                                        identification_name: 'testmilandrchicken-mc', db_status: 'undefined'}
  let!(:program_op) {FactoryGirl.create :program, instance: instance, program_type: 'op', database_name: 'op_testmilandrchicken',
                                        identification_name: 'testmilandrchicken-op', db_status: 'undefined'}
  let!(:program_cli) {FactoryGirl.create :program, instance: instance, program_type: 'dcs-cli', database_name: 'dcs4_testmilandrchicken',
                                         identification_name: 'testmilandrchicken-dcs-cli', db_status: 'undefined'}
  let!(:program_dev) {FactoryGirl.create :program, instance: instance, program_type: 'dcs-dev',
                                         identification_name: 'testmilandrchicken-dcs-dev', db_status: 'undefined'}
end
