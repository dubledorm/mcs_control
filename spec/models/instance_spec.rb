require 'rails_helper'

#RSpec.describe Instance, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"
#end


describe Instance do
  describe 'factory' do
    let(:instance) {FactoryGirl.create :instance}

    # Factories
    it { expect(instance).to be_valid }

    # Validations
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { expect(FactoryGirl.build(:instance, name: "")).to be_invalid}
    it { expect(FactoryGirl.build(:instance, name: "the_name1234")).to be_valid}
    it { expect(FactoryGirl.build(:instance, name: "the-name1234")).to be_invalid}


  end
end
