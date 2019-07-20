require 'rails_helper'

describe Port do
    describe '.find_free_service' do

      context 'when bad argument' do
        it {expect{Port::FindFreeService.new(:error_type).call}.to raise_error ArgumentError}
      end

      context 'when bring range of http diapason' do # Заполнен весь http диапазон
        before :each do
          (Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]..Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range]).each do |port|
            FactoryGirl.create(:port, number: port)
          end
        end

        it {expect{Port::FindFreeService.new(:http).call}.to raise_error StandardError}
        it {expect{Port::FindFreeService.new(:tcp).call}.to_not raise_error}
      end

      context 'when base is empty' do
        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        it {expect(Port::FindFreeService.new(:tcp).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:tcp][:left_range])}
      end

      context 'when left range exist' do
        let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 1)}

      end

      context 'when right range exist' do
        let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range]}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
      end

      context 'when empty place exists' do # есть дырки в диапазоне
        let!(:port1)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range]}
        let!(:port2)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 1 }
        let!(:port3)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 3}

        it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] + 2)}

      end

      context 'when existing values do not lay into diapason' do
        context 'when its lay after right range' do
          let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:right_range] + 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        end

        context 'when its lay before left range' do
          let!(:port)  {FactoryGirl.create :port, number: Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range] - 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(Port::FindFreeService::RANGE_OF_NUMBER[:http][:left_range])}
        end
      end
    end
end
