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
    it { expect(FactoryGirl.build(:program, additional_name: 'the_name1234')).to be_invalid}
    it { expect(FactoryGirl.build(:program, additional_name: 'the-name1234', program_type: 'abrakadabra')).to be_invalid}
    it { expect(FactoryGirl.build(:program, identification_name: '')).to be_invalid}
    it { expect(FactoryGirl.build(:program, identification_name: 'the-name1234')).to be_valid}
    it { expect(FactoryGirl.build(:program, identification_name: 'the_name1234')).to be_invalid}


    # Relationships
    it {should belong_to(:instance)}
    it {should have_many(:ports)}

  end
end
