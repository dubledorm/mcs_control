require 'rails_helper'

describe Port do
    describe '#find_free_service' do
      before :each do
        allow(NginxConfig).to receive(:config).
            and_return( { http_ports_range: [[30000, 31000]], stream_ports_range: [[31001, 64000]] } )
      end

      context 'when bad argument' do
        it {expect{Port::FindFreeService.new(:error_type).call}.to raise_error ArgumentError}
      end

      context 'when bring range of http diapason' do # Заполнен весь http диапазон
        before :each do
          #(Port::RANGE_OF_NUMBER[:http][:left_range]..Port::RANGE_OF_NUMBER[:http][:right_range]).each do |port|
          NginxConfig::ranges(:http).each do |range|
            (range[0]..range[1]).each do |port|
              FactoryGirl.create(:port, number: port)
            end
          end
        end

        it {expect{Port::FindFreeService.new(:http).call}.to raise_error StandardError}
        it {expect{Port::FindFreeService.new(:tcp).call}.to_not raise_error}
      end

      context 'when base is empty' do
        it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http))}
        it {expect(Port::FindFreeService.new(:tcp).call).to eq(NginxConfig::first_port(:tcp))}
      end

      context 'when left range exist' do
        let!(:port)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http)}

        it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http) + 1)}

      end

      context 'when right range exist' do
        let!(:port)  {FactoryGirl.create :port, number: NginxConfig::ranges(:http)[0][1]}

        it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http))}
      end

      context 'when empty place exists' do # есть дырки в диапазоне
        let!(:port1)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http)}
        let!(:port2)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http) + 1 }
        let!(:port3)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http) + 3}

        it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http) + 2)}

      end

      context 'when existing values do not lay into diapason' do
        context 'when its lay after right range' do
          let!(:port)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http) + 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http))}
        end

        context 'when its lay before left range' do
          let!(:port)  {FactoryGirl.create :port, number: NginxConfig::first_port(:http) - 10}

          it {expect(Port::FindFreeService.new(:http).call).to eq(NginxConfig::first_port(:http))}
        end
      end
    end

  describe 'find_free_service and 2 ranges' do
    before :each do
      allow(NginxConfig).to receive(:config).
          and_return( { http_ports_range: [[30000, 31000], [65000, 66000]], stream_ports_range: [[31001, 64000]] } )
    end

    context 'when bring range of http diapason' do # Заполнен весь http диапазон
      before :each do
        NginxConfig::ranges(:http).each do |range|
          (range[0]..range[1]).each do |port|
            FactoryGirl.create(:port, number: port)
          end
        end
      end

      it {expect{Port::FindFreeService.new(:http).call}.to raise_error StandardError}
      it {expect{Port::FindFreeService.new(:tcp).call}.to_not raise_error}
    end

    context 'when bring range of first http diapason' do # Заполнен весь первый http диапазон
      before :each do
        range = NginxConfig::ranges(:http)[0]
        (range[0]..range[1]).each do |port|
          FactoryGirl.create(:port, number: port)
        end
      end

      it {expect(Port::FindFreeService.new(:http).call).to eq(65000)}

      context 'when empty place exists' do # есть дырки в диапазоне
        let!(:port1)  {FactoryGirl.create :port, number: 65000 }
        let!(:port2)  {FactoryGirl.create :port, number: 65001 }
        let!(:port3)  {FactoryGirl.create :port, number: 65003 }

        it {expect(Port::FindFreeService.new(:http).call).to eq(65002)}
      end
    end
  end
end
