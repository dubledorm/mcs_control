require 'rails_helper'
require 'support/shared/application_decorator'
require 'support/shared/object_base_decorator'

RSpec.describe Port do

  it_behaves_like 'application_decorator'

  it_behaves_like 'base_decorator'

  describe '#program_name' do
    context 'when program_id does not define' do
      it 'should return empty' do
        my_port = Port.new()
        expect(my_port.decorate.program_name).to eq('')
      end
    end

    context 'when program_id exists' do
      let!(:port) {FactoryGirl.create :port}
      it {expect(port.decorate.program_name).to eq(port.program.identification_name)}
    end
  end
end
