require 'rails_helper_without_transactions'
require 'database_tools'
require 'support/shared/instance_thick_collate'

describe Instance::DatabaseControl::CollateWithDbService do
  include DatabaseTools
  context 'when program`s databases do not exist' do
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

  context 'when program`s databases exist' do
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

  context 'when programs do not exist while databases exist' do
    let!(:instance) {FactoryGirl.create :instance, name: 'testmilandrchicken', db_user_name: 'testmilandrchicken', db_status: 'undefined'}

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )

      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    it { expect(instance.programs.count).to eq(4) }
    it { expect(instance.programs.dcs_dev_only.first.sym_db_status).to eq(:undefined) }
    it { expect(instance.programs.op_only.first.sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs.mc_only.first.sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs.dcs_cli_only.first.sym_db_status).to eq(:only_there_exists) }
  end

  context 'when one database name looks like another' do # Закрываем ошибку по нахождению базы
    include_context 'instance with content'

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchickennn' )

      Instance::DatabaseControl::CollateWithDbService.new(instance).call
      program_mc.reload
      program_op.reload
      program_cli.reload
      program_dev.reload
    end

    it { expect(instance.programs.count).to eq(4) }
    it {expect(program_mc.sym_db_status).to eq(:everywhere_exists)}
    it {expect(program_op.sym_db_status).to eq(:only_here_exists)}
    it {expect(program_cli.sym_db_status).to eq(:only_here_exists)}
    it {expect(program_dev.sym_db_status).to eq(:only_here_exists)}
  end


  context 'when programs do not exist while some databases exist' do # Закрываем ошибку по базе с цифрой в конце
    let!(:instance) {FactoryGirl.create :instance, name: 'testmilandrchicken', db_user_name: 'testmilandrchicken', db_status: 'undefined'}

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken_2' )

      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    it { expect(instance.programs.count).to eq(5) }
    it { expect(instance.programs.dcs_dev_only.first.sym_db_status).to eq(:undefined) }
    it { expect(instance.programs.dcs_cli_only.first.sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs.op_only.first.sym_db_status).to eq(:only_there_exists) }
    it { expect(instance.programs.mc_only.count).to eq(2) }
    it { expect(instance.programs.mc_only.first.sym_db_status).to eq(:only_there_exists) }
  end

  context 'when programs do not exist while databases exist and http config exists' do
    let!(:instance) {FactoryGirl.create :instance, name: 'testmilandrchicken', db_user_name: 'testmilandrchicken', db_status: 'undefined'}
    FILE_CONTENT = 'upstream identification_testmilandrchicken_mc_backend {
  server 192.168.100.11:462;
  server 192.168.100.12:462;
  server 192.168.100.14:462;
  server 192.168.100.24:462;
}
server {
  listen 462;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_testmilandrchicken_mc_backend;
  }
}

upstream testmilandrchicken_op {
  server 192.168.100.11:463;
  server 192.168.100.12:463;
  server 192.168.100.14:463;
  server 192.168.100.24:463;
}
server {
  listen 463;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /operator permanent;
  }
  location /operator {
  proxy_pass http://testmilandrchicken_op;
  }
}'.freeze


    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )

      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      file = File.open(dest_file_name, 'w')
      file.write(FILE_CONTENT)
      file.close
      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    it { expect(instance.programs.count).to eq(4) }
    it { expect(instance.programs.op_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.op_only.first.ports.first.number).to eq(463) }
    it { expect(instance.programs.mc_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.first.ports.first.number).to eq(462) }
  end
end
