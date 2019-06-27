require 'rails_helper'

describe Program do
  describe 'factory' do
    let!(:program) {FactoryGirl.create :program}

    # Factories
    it { expect(program).to be_valid }

    # Validations
    it { should validate_presence_of(:database_name) }
    it { should validate_presence_of(:identification_name) }
    it { should validate_presence_of(:program_type) }
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

  end

  shared_examples 'identification_name right' do
    before :each do
      program.set_identification_name
    end
    it { expect(program).to be_valid }
  end

  shared_examples 'identification_name wrong' do
    before :each do
      program.set_identification_name
    end
    # noinspection RubyResolve
    it { expect(program).to be_invalid }
  end

  describe 'identification_name' do
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
end
