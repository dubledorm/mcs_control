require 'rails_helper'

describe Retranslator do
  describe 'factory' do
    let!(:retranslator) {FactoryGirl.create :retranslator}

    # Factories
    it { expect(retranslator).to be_valid }

    # Validations
    it { should validate_presence_of(:port_from) }
    it { should validate_presence_of(:port_to) }
    it { should validate_uniqueness_of(:port_from) }
    it { should validate_uniqueness_of(:port_to) }

    # Relationships
    it {should belong_to(:admin_user)}
  end

  describe 'has_free_port' do
    context 'when nothing retranslators exist' do
      it { expect(Retranslator::has_free_port?).to eq(false) }
    end

    context 'when one retranslator is free' do
      let!(:retranslator) { FactoryGirl.create(:retranslator, active: false) }

      it { expect(Retranslator::has_free_port?).to eq(true) }
    end

    context 'when one retranslator is busy' do
      let!(:retranslator) { FactoryGirl.create(:retranslator, active: true) }

      it { expect(Retranslator::has_free_port?).to eq(false) }
    end

    context 'when two retranslator exist and one of them is free' do
      let!(:retranslator1) { FactoryGirl.create(:retranslator, active: true) }
      let!(:retranslator2) { FactoryGirl.create(:retranslator) }

      it { expect(Retranslator::has_free_port?).to eq(true) }
    end
  end

  describe 'channel_name' do
    let!(:retranslator) { FactoryGirl.create(:retranslator, port_from: 3001, port_to: 3002) }

    it { expect(retranslator.channel_name).to eq('3001_3002') }

    it { expect(Retranslator.channel_name_port_from('3001_3002')).to eq(3001) }
    it { expect(Retranslator.channel_name_port_to('3001_3002')).to eq(3002) }
    it { expect(Retranslator.all.by_channel('3001_3002').first).to eq(retranslator) }
  end
end
