require 'rails_helper'
require 'database_name'

describe Program do
  include DatabaseName
  
  describe 'factory' do
    let!(:program) {FactoryGirl.create :program}
    let!(:mc_program) {FactoryGirl.create :mc_program}
    let!(:op_program) {FactoryGirl.create :op_program}
    let!(:cli_program) {FactoryGirl.create :cli_program}
    let!(:dev_program) {FactoryGirl.create :dev_program}



    # Factories
    it { expect(program).to be_valid }
    it { expect(mc_program).to be_valid }
    it { expect(op_program).to be_valid }
    it { expect(cli_program).to be_valid }
    it { expect(dev_program).to be_valid }


    # Validations
    it { should validate_presence_of(:identification_name) }
    it { should validate_presence_of(:program_type) }
    it { should validate_presence_of(:instance) }
    it { should validate_uniqueness_of(:database_name) }
    it { should validate_uniqueness_of(:identification_name) }
    it { expect(FactoryGirl.build(:program, additional_name: '')).to be_valid}
    it { expect(FactoryGirl.build(:program, additional_name: 'the-name1234')).to be_valid}
    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:program, additional_name: 'the_name1234')).to be_invalid}
    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:program, additional_name: 'the-name1234', program_type: 'error_type')).to be_invalid}
    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:program, identification_name: '')).to be_invalid}
    it { expect(FactoryGirl.build(:program, identification_name: 'the-name1234')).to be_valid}
    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:program, identification_name: 'the_name1234')).to be_invalid}


    # Relationships
    it {should belong_to(:instance)}
    it {should have_many(:ports)}
    it {should have_many(:stored_files)}
  end

  shared_examples 'identification_name right' do
    before :each do
      program.identification_name = make_identification_name(instance.name, program.program_type, program.additional_name)
    end
    it { expect(program).to be_valid }
  end

  shared_examples 'identification_name wrong' do
    before :each do
      program.identification_name = make_identification_name(instance.name, program.program_type, program.additional_name)
    end
    # noinspection RubyResolve
    it { expect(program).to be_invalid }
  end

  describe '#identification_name' do
    it_should_behave_like 'identification_name right' do
      let!(:instance) {FactoryGirl.build :instance, name: 'energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fabric'}
    end

    it_should_behave_like 'identification_name right' do
      let!(:instance) {FactoryGirl.build :instance, name: 'super-energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'super-fabric'}
    end

    it_should_behave_like 'identification_name right' do
      let!(:instance) {FactoryGirl.build :instance, name: 'super-energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'op', additional_name: 'super-fabric'}
    end

    it_should_behave_like 'identification_name right' do
      let!(:instance) {FactoryGirl.build :instance, name: 'super-energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'dcs-dev', additional_name: 'super-fabric'}
    end

    it_should_behave_like 'identification_name right' do
      let!(:instance) {FactoryGirl.build :instance, name: 'super-energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'dcs-cli', additional_name: 'super-fabric'}
    end

    it_should_behave_like 'identification_name wrong' do
      let!(:instance) {FactoryGirl.build :instance, name: 'super_energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'fabric'}
    end

    it_should_behave_like 'identification_name wrong' do
      let!(:instance) {FactoryGirl.build :instance, name: 'energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'm_c', additional_name: 'fabric'}
    end

    it_should_behave_like 'identification_name wrong' do
      let!(:instance) {FactoryGirl.build :instance, name: 'energizer'}
      let(:program) {FactoryGirl.build :program, instance: instance, program_type: 'mc', additional_name: 'super_fabric'}
    end
  end

  describe '#can_add_port?' do
    it { expect(FactoryGirl.build( :program, program_type: 'dcs-dev').can_add_port?).to eq(true) }
    it { expect(FactoryGirl.build( :program, program_type: 'dcs-cli').can_add_port?).to eq(false) }
    it { expect(FactoryGirl.build( :program, program_type: 'op').can_add_port?).to eq(false) }
    it { expect(FactoryGirl.build( :program, program_type: 'mc').can_add_port?).to eq(false) }
  end

  describe '#can_collate_with_db?' do
    it { expect(FactoryGirl.build( :program, program_type: 'dcs-dev').can_collate_with_db?).to eq(true) }
    it { expect(FactoryGirl.build( :program, program_type: 'dcs-cli').can_collate_with_db?).to eq(false) }
    it { expect(FactoryGirl.build( :program, program_type: 'op').can_collate_with_db?).to eq(false) }
    it { expect(FactoryGirl.build( :program, program_type: 'mc').can_collate_with_db?).to eq(false) }
  end

  describe '#create' do
    let!(:instance) {FactoryGirl.build :instance, name: 'testmilandrchicken'}

    # noinspection RubyResolve
    it { expect(FactoryGirl.build(:program, program_type: 'mc',
                                  database_name: 'mc_testmilandrchicken_2',
                                  identification_name: make_identification_name(instance.name,
                                                                                'mc',
                                                                                '2'))).to be_valid}

  end
end
