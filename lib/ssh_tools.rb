# encoding: utf-8
require 'net/scp'

module SshTools

  def self.scp_tmp_file(dest_host, dest_host_user, dest_host_password, dest_file_path, src_file_name)
    Rails.logger.info 'Before Sent file ' + src_file_name + ' to destination host ' + dest_host +
    ' dest_host_password = ' + dest_host_password + ' dest_file_path = ' + dest_file_path

    Net::SCP.start(dest_host, dest_host_user, { password: dest_host_password } ) do |scp|
      scp.upload!( src_file_name, dest_file_path )
    end

    Rails.logger.info 'Sent file ' + src_file_name + ' to destination host ' + dest_host
  end

  def self.scp_download_to_tmp_file(src_host, src_host_user, src_host_password, dest_file_path, src_file_path)
    Net::SCP.start(src_host, src_host_user, { password: src_host_password } ) do |scp|
      scp.download!( src_file_path, dest_file_path )
    end

    Rails.logger.info 'Receive file ' + src_file_path + ' to destination file ' + dest_file_path
  end
end
