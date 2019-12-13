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
end
