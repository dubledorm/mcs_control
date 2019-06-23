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
end
