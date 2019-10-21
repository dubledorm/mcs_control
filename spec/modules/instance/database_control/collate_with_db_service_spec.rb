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

    after :each do
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
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

    after :each do
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
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

    after :each do
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchickennn' )
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

    after :each do
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken_2' )
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

    after :each do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'testmilandrchicken.conf')
      File.delete(dest_file_name)

      drop_database( ActiveRecord::Base.connection, 'mc_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'op_testmilandrchicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_testmilandrchicken' )
    end

    it { expect(instance.programs.count).to eq(4) }
    it { expect(instance.programs.op_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.op_only.first.ports.first.number).to eq(463) }
    it { expect(instance.programs.mc_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.first.ports.first.number).to eq(462) }
  end

  context 'when database has name mc_chicken_2' do
    let!(:instance) {FactoryGirl.create :instance, name: 'chicken', db_user_name: 'chicken', db_status: 'undefined'}
    FILE_CONTENT = 'upstream identification_chicken_mc_backend {
  server 192.168.100.11:462;
  server 192.168.100.12:462;
  server 192.168.100.14:462;
  server 192.168.100.24:462;
}
server {
  listen 461;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_chicken_mc_backend;
  }
}
server {
  listen 462;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_chicken_2_mc_backend;
  }
}

upstream chicken_op {
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
  proxy_pass http://inf_chicken_op_backend;
  }
}'.freeze

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_chicken' )
      create_database( ActiveRecord::Base.connection, 'mc_chicken_2' )
      create_database( ActiveRecord::Base.connection, 'op_chicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_chicken' )

      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'chicken.conf')
      file = File.open(dest_file_name, 'w')
      file.write(FILE_CONTENT)
      file.close
      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    after :each do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'chicken.conf')
      File.delete(dest_file_name)
      drop_database( ActiveRecord::Base.connection, 'mc_chicken' )
      drop_database( ActiveRecord::Base.connection, 'mc_chicken_2' )
      drop_database( ActiveRecord::Base.connection, 'op_chicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_chicken' )
    end

    it { expect(instance.programs.count).to eq(5) }
    it { expect(instance.programs.op_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.op_only.first.ports.first.number).to eq(463) }
    it { expect(instance.programs.mc_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.first.ports.first.number).to eq(461) }
    it { expect(instance.programs.mc_only.last.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.last.ports.first.number).to eq(462) }
  end

  context 'when pp_xxx exists' do
    let!(:instance) {FactoryGirl.create :instance, name: 'chicken', db_user_name: 'chicken', db_status: 'undefined'}
    FILE_CONTENT = 'upstream identification_chicken_mc_backend {
  server 192.168.100.11:462;
  server 192.168.100.12:462;
  server 192.168.100.14:462;
  server 192.168.100.24:462;
}
server {
  listen 461;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_chicken_mc_backend;
  }
}
server {
  listen 462;
  server_name infsphr.info;
  location = / {
  rewrite ^.+ /mc permanent;
  }
  location /mc {
  proxy_pass http://identification_chicken_2_mc_backend;
  }
}

upstream chicken_op {
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
  proxy_pass http://inf_chicken_op_backend;
  }
}

upstream chicken_pp_web_backend {

    # upstream cluster - NodePort is running on all k8s hosts,

    # so we can connect to any available

    server 192.168.100.11:30046;

    server 192.168.100.12:30046;

    server 192.168.100.14:30046;

    server 192.168.100.24:30046;

    server 192.168.100.20:30046;

}



upstream chicken_pp_router_backend {

    # upstream cluster - NodePort is running on all k8s hosts,

    # so we can connect to any available

    server 192.168.100.11:30048;

    server 192.168.100.12:30048;

    server 192.168.100.14:30048;

    server 192.168.100.24:30048;

    server 192.168.100.20:30048;

}



upstream chicken_pp_admin_backend {

    # upstream cluster - NodePort is running on all k8s hosts,

    # so we can connect to any available

    server 192.168.100.11:30047;

    server 192.168.100.12:30047;

    server 192.168.100.14:30047;

    server 192.168.100.24:30047;

    server 192.168.100.20:30047;

}



server {

    # pp block

    listen 30046;

    server_name infsphr.info;



    location / {

        proxy_pass http://chicken_pp_web_backend;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_set_header Host infsphr.info;

    }

}



server {

    # pp admin company block

    listen 30047;

    server_name infsphr.info;



    location / {

        proxy_pass http://chicken_pp_admin_backend;

    }

}



server {

    # pp router block

    listen 30048;

    server_name infsphr.info;



    location / {

        proxy_pass http://chicken_pp_router_backend;

    }

}




'.freeze

    before :each do
      create_database( ActiveRecord::Base.connection, 'mc_chicken' )
      create_database( ActiveRecord::Base.connection, 'mc_chicken_2' )
      create_database( ActiveRecord::Base.connection, 'op_chicken' )
      create_database( ActiveRecord::Base.connection, 'dcs4_chicken' )
      create_database( ActiveRecord::Base.connection, 'pp_router_chicken' )
      create_database( ActiveRecord::Base.connection, 'pp_web_chicken' )


      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'chicken.conf')
      file = File.open(dest_file_name, 'w')
      file.write(FILE_CONTENT)
      file.close
      Instance::DatabaseControl::CollateWithDbService.new(instance).call
    end

    after :each do
      dest_file_name = File.join(NginxConfig.config[:nginx_http_config_path], 'chicken.conf')
      File.delete(dest_file_name)
      drop_database( ActiveRecord::Base.connection, 'mc_chicken' )
      drop_database( ActiveRecord::Base.connection, 'mc_chicken_2' )
      drop_database( ActiveRecord::Base.connection, 'op_chicken' )
      drop_database( ActiveRecord::Base.connection, 'dcs4_chicken' )
      drop_database( ActiveRecord::Base.connection, 'pp_router_chicken' )
      drop_database( ActiveRecord::Base.connection, 'pp_web_chicken' )
    end

    it { expect(instance.programs.count).to eq(7) }
    it { expect(instance.programs.op_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.op_only.first.ports.first.number).to eq(463) }
    it { expect(instance.programs.mc_only.first.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.first.ports.first.number).to eq(461) }
    it { expect(instance.programs.mc_only.last.ports.count).to eq(1) }
    it { expect(instance.programs.mc_only.last.ports.first.number).to eq(462) }
    it { expect(instance.programs.pp_router_only.last.ports.count).to eq(1) }
    it { expect(instance.programs.pp_router_only.last.ports.first.number).to eq(30048) }
    it { expect(instance.programs.pp_web_only.last.ports.count).to eq(1) }
    it { expect(instance.programs.pp_web_only.last.ports.first.number).to eq(30046) }
  end
end
