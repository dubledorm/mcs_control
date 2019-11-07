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

  describe 'validation for_instance_only' do
    it { expect((FactoryGirl.build :nginx_template, for_instance_only: true).valid?).to be(false) }
    it { expect((FactoryGirl.build :nginx_template_with_instance, for_instance_only: true).valid?).to be(true) }
    it { expect((FactoryGirl.build :nginx_template, for_instance_only: false).valid?).to be(true) }
    it { expect((FactoryGirl.build :nginx_template_with_instance, for_instance_only: false).valid?).to be(true) }
  end

  describe 'get_by_http_and_program_type' do

    context 'when instance not set and use_for_http is true' do
      let!(:nginx_template_mc) {FactoryGirl.create :nginx_template, program_type: 'mc', use_for_http: true}
      let!(:nginx_template_op) {FactoryGirl.create :nginx_template, program_type: 'op', use_for_http: true}
      let!(:program_mc) { FactoryGirl.create :program, program_type: 'mc' }
      let!(:program_op) { FactoryGirl.create :program, program_type: 'op' }

      it { expect(NginxTemplate::get_by_http_and_program_type(program_mc)).to eq(nginx_template_mc.content_http) }
      it { expect(NginxTemplate::get_by_http_and_program_type(program_op)).to eq(nginx_template_op.content_http) }
    end

    context 'when instance not set and use_for_http is false' do
      let!(:nginx_template_mc) {FactoryGirl.create :nginx_template, program_type: 'mc', use_for_http: false}
      let!(:nginx_template_op) {FactoryGirl.create :nginx_template, program_type: 'op', use_for_http: false}
      let!(:program_mc) { FactoryGirl.create :program, program_type: 'mc' }
      let!(:program_op) { FactoryGirl.create :program, program_type: 'op' }

      it { expect(NginxTemplate::get_by_http_and_program_type(program_mc)).to eq(nil) }
      it { expect(NginxTemplate::get_by_http_and_program_type(program_op)).to eq(nil) }
    end

    context 'when instance exists' do
      let!(:program_mc) { FactoryGirl.create :program, program_type: 'mc' }
      let!(:program_mc1) { FactoryGirl.create :program, program_type: 'mc' }
      let!(:program_mc2) { FactoryGirl.create :program, program_type: 'mc' }

      let!(:nginx_template_mc) {FactoryGirl.create :nginx_template, program_type: 'mc',
                                                   use_for_http: true, instance: program_mc.instance}
      let!(:nginx_template_mc1) {FactoryGirl.create :nginx_template, program_type: 'mc',
                                                    use_for_http: true, instance: program_mc1.instance}
      let!(:nginx_template_mc2) {FactoryGirl.create :nginx_template, program_type: 'mc'}

      it { expect(NginxTemplate::get_by_http_and_program_type(program_mc)).to eq(nginx_template_mc.content_http) }
      it { expect(NginxTemplate::get_by_http_and_program_type(program_mc1)).to eq(nginx_template_mc1.content_http) }
      it { expect(NginxTemplate::get_by_http_and_program_type(program_mc2)).to eq(nginx_template_mc2.content_http) }
    end
  end
end
