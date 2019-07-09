require 'rails_helper_without_transactions'
require 'database_tools'

describe Instance::Destructor do
  include DatabaseTools

  before :each do
    @instance =  Instance::Factory::build_and_create_db(Instance.new(name: 'testmilandrchicken'))
  end

  it {expect(Instance.count).to eq(1)}

  it {expect(Program.count).to eq(4)}

  it {expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken')).to be(true)}
  it {expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrchicken')).to be(true)}
  it {expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrchicken')).to be(true)}



  it 'should decrement Program.count' do
    expect{Instance::Destructor::destroy_and_drop_db(@instance)}.to change(Program, :count).by(-4)
  end

  it 'should drop databases ' do
    Instance::Destructor::destroy_and_drop_db(@instance)
    expect(get_database_list(ActiveRecord::Base.connection).include?('mc_testmilandrchicken')).to be(false)
    expect(get_database_list(ActiveRecord::Base.connection).include?('op_testmilandrchicken')).to be(false)
    expect(get_database_list(ActiveRecord::Base.connection).include?('dcs4_testmilandrchicken')).to be(false)
  end
end