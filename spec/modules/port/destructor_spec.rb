require 'rails_helper'
require 'support/shared/instance_thick_collate'

describe Port::Destructor do
  include_context 'instance with content'
  let!(:port) {FactoryGirl.create :port, program: program_dev}

  it 'should decrement Port.count' do
    expect{Port::Destructor::simple_destroy(port)}.to change(Port, :count).by(-1)
  end
end