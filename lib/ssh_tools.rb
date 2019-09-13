# encoding: utf-8
require 'net/scp'

module SshTools

  def self.scp_tmp_file(dest_host, dest_host_user, dest_host_password, dest_file_path, src_file_name)
    Net::SCP.start(dest_host, dest_host_user, { password: dest_host_password } ) do |scp|
      scp.upload!( src_file_name, dest_file_path )
    end

    Rails.logger.info 'Sent file ' + src_file_name + ' to destination host ' + dest_host
  end
end
