require 'rails_helper'

describe NginxTemplate do
  describe 'factory' do
    let!(:nginx_template) {FactoryGirl.create :nginx_template}

    # Factories
    it { expect(nginx_template).to be_valid }

    # Validations
    it { should validate_presence_of(:program_type) }
  end
end
