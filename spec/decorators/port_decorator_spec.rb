require 'rails_helper'
require 'support/shared/application_decorator'

RSpec.describe Port do
  subject { FactoryGirl.create(:port) }

  it_behaves_like 'application_decorator'

  describe '#program_name' do
    context 'when program_id does not define' do
      it 'should return empty' do
        my_port = Port.new()
        expect(my_port.decorate.program_name).to eq('')
      end
    end

    context 'when program_id exists' do
      it {expect(subject.decorate.program_name).to eq(subject.program.identification_name)}
    end
  end
end
