require 'rails_helper'

describe AssistantSoft::Pf2 do

  it { expect{ described_class.new }.to_not raise_exception}

  context 'when nothing program exists' do
    it { expect{ described_class.new.find_program }.to raise_exception(StandardError)}
  end

  context 'when pf2 program does not exist' do
    let!(:mc_program) {FactoryGirl.create :mc_program}
    let!(:dev_program) {FactoryGirl.create :dev_program}

    it { expect{ described_class.new.find_program }.to raise_exception(StandardError)}
  end

  context 'when pf2 program exists' do
    let!(:mc_program) {FactoryGirl.create :mc_program}
    let!(:pf2_program) {FactoryGirl.create :pf2_program}
    let!(:dev_program) {FactoryGirl.create :dev_program}

    it { expect(described_class.new.find_program).to eq(pf2_program) }
  end
end