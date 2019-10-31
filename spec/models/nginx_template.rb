require 'rails_helper'

describe NginxTemplate do
  describe 'factory' do
    let!(:nginx_template) {FactoryGirl.create :nginx_template}
    let!(:nginx_template_with_instance) {FactoryGirl.create :nginx_template_with_instance}


    # Factories
    it { expect(nginx_template).to be_valid }
    it { expect(nginx_template_with_instance).to be_valid }


    # Validations
    it { should validate_presence_of(:program_type) }

    # Relationships
    it {should belong_to(:instance)}
  end

  describe 'validation uniqnes program_type' do
    context 'when instance_id is nil' do
      let!(:nginx_template) {FactoryGirl.create :nginx_template, program_type: 'mc'}

      it { expect((FactoryGirl.build :nginx_template, program_type: 'mc').valid?).to be(false) }
      it { expect((FactoryGirl.build :nginx_template, program_type: 'op').valid?).to be(true) }
      it { expect((FactoryGirl.build :nginx_template_with_instance, program_type: 'mc').valid?).to be(true) }
    end

    context 'when instance_id exists' do
      let!(:instance) { FactoryGirl.create :instance }
      let!(:nginx_template) {FactoryGirl.create :nginx_template, program_type: 'mc', instance: instance}

      it { expect((FactoryGirl.build :nginx_template, program_type: 'mc',
                                     instance: instance).valid?).to be(false) }
      it { expect((FactoryGirl.build :nginx_template, program_type: 'op',
                                     instance: instance).valid?).to be(true) }
      it { expect((FactoryGirl.build :nginx_template_with_instance, program_type: 'mc').valid?).to be(true) }
      it { expect((FactoryGirl.build :nginx_template, program_type: 'mc').valid?).to be(true) }
    end
  end
end
