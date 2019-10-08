# encoding: utf-8
require 'tempfile'
module FileTools

  def self.create_tmp_file
    file = Tempfile.new('mcs_control')
    file.close
    file
  end

  def self.create_and_fill_tmp_file(body_str)
    return nil if body_str.blank?
    file = Tempfile.new('mcs_control')
    file.write(body_str)
    file.close
    file
  end

  def self.remove_file(file)
    file.unlink
  end

  def self.create_full_path(path, file_name)
    File.join(path, file_name)
  end

  def self.read_file(file)
    file.open
    file.rewind
    result = file.read
    file.close
    result
  end
end