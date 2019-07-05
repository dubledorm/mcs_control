require 'rails_helper'
require 'database_tools'
require 'infosphera_sql'

describe InfospheraSql do
  include DatabaseTools
  include InfospheraSql

  describe 'get_all_ports_of_uspd' do
    before :each do
      config   = Rails.configuration.database_configuration
      @connection = get_custom_connection('temporary',
                                          config[Rails.env]['host'],
                                          config[Rails.env]['port'],
                                         'op_infosphera_test',
                                          config[Rails.env]["admin_username"],
                                          config[Rails.env]["admin_password"])
    end
    
    after :each do
      close_custom_connection
    end

    it {expect(get_all_ports_of_uspd(@connection).count).to eq(1)}
    it {expect(get_all_ports_of_uspd(@connection)[0]['input_value']).to eq('9003')}
    it {expect(get_all_ports_of_uspd(@connection)[0]['serial_number']).to eq('868728033860047')}
  end
end
