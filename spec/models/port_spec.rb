require 'rails_helper'

describe Port do
  describe 'factory' do
    let!(:port) {FactoryGirl.create :port}

    # Factories
    it { expect(port).to be_valid }

    # Validations
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:instance) }
    it { should validate_uniqueness_of(:number) }

    # Relationships
    it {should belong_to(:instance)}

  end


  describe 'services' do
    describe 'find_free_service' do

      describe 'bad argument' do
        it {expect{Port::FindFreeService.new(:abrval).call}.to raise_error ArgumentError}
      end

      describe 'bring_range_of_diapason' do
        before :each do
          (Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]..Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range]).each do |port|
            FactoryGirl.create(:port, number: port)
          end
        end

        it {expect{Port::FindFreeService.new(:http).call}.to raise_error StandardError}
        it {expect{Port::FindFreeService.new(:tcp).call}.to_not raise_error}
      end

      describe 'for empty base' do
        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        it {expect(Port::FindFreeService.new(:tcp).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:tcp][:left_range])}
      end

      describe 'left range exist' do
        let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 1)}

      end

      describe 'right range exist' do
        let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range]}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
      end

      describe 'empty place exists' do
        let!(:port1)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]}
        let!(:port2)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 1 }
        let!(:port3)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 3}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 2)}

      end

      describe 'existing values do not lay into diapason' do
        context 'right range' do
          let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range] + 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        end

        context 'left range' do
          let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] - 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        end
      end
    end
  end
end
