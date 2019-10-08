# encoding: utf-8
module NginxTools

  def self.nginx_http_file_name(instance)
    "#{instance.name}.conf"
  end

  def self.nginx_stream_file_name(instance)
    "#{instance.name}.conf"
  end
end