require 'rails_helper'

describe AdminUser do
  describe 'factory' do
    let!(:admin_user) {FactoryGirl.create :admin_user}

    # Factories
    it { expect(admin_user).to be_valid }

    # Relationships
    it {should have_and_belong_to_many(:roles)}
    it {should have_many(:instances)}
    it {should have_many(:programs)}
  end

  describe '#instances' do
    let!(:admin_user) {FactoryGirl.create :admin_user}
    let!(:instance) {FactoryGirl.create :instance}

    it { expect(admin_user.instances.count).to eq(0) }

    context 'when role_name == manager' do
      before :each do
        admin_user.add_role :manager, instance
      end

      it { expect(admin_user.has_role?(:manager, instance)).to be(true) }
      it { expect(admin_user.instances.count).to eq(1) }
      it { expect(admin_user.instances[0]).to eq(instance) }
    end
  end

  describe '#programs' do
    let!(:admin_user) {FactoryGirl.create :admin_user}
    let!(:program) {FactoryGirl.create :program}

    it { expect(admin_user.programs.count).to eq(0) }

    context 'when role_name == editor' do
      before :each do
        admin_user.add_role :editor, program.instance
      end

      it { expect(admin_user.has_role?(:editor, program.instance)).to be(true) }
      it { expect(admin_user.programs.count).to eq(1) }
      it { expect(admin_user.programs[0]).to eq(program) }
    end
  end

  describe '#ports' do
    let!(:admin_user) {FactoryGirl.create :admin_user}
    let!(:port) {FactoryGirl.create :port}

    it { expect(admin_user.ports.count).to eq(0) }

    context 'when role_name == editor' do
      before :each do
        admin_user.add_role :editor, port.program.instance
      end

      it { expect(admin_user.has_role?(:editor, port.program.instance)).to be(true) }
      it { expect(admin_user.ports.count).to eq(1) }
      it { expect(admin_user.ports[0]).to eq(port) }
    end
  end

  describe '#role_name' do

    context 'when it two instances' do
      let!(:admin_user) {FactoryGirl.create :admin_user}
      let!(:port) {FactoryGirl.create :port}
      let!(:port1) {FactoryGirl.create :port}

      before :each do
        admin_user.add_role :editor, port.program.instance
        admin_user.add_role :manager, port1.program.instance
      end

      it { expect(admin_user.has_role?(:editor, port.program.instance)).to be(true) }
      it { expect(admin_user.ports.where(roles: { name: :editor }).count).to eq(1) }
      it { expect(admin_user.ports.where(roles: { name: :editor })[0]).to eq(port) }

      it { expect(admin_user.has_role?(:manager, port1.program.instance)).to be(true) }
      it { expect(admin_user.ports.where(roles: { name: :manager }).count).to eq(1) }
      it { expect(admin_user.ports.where(roles: { name: :manager })[0]).to eq(port1) }
    end

    context 'when it one instance' do
      let!(:admin_user) {FactoryGirl.create :admin_user}
      let!(:program) {FactoryGirl.create :program}
      let!(:port) {FactoryGirl.create :port, program: program}
      let!(:port1) {FactoryGirl.create :port, program: program}

      before :each do
        admin_user.add_role :editor, program.instance
        admin_user.add_role :manager, program.instance
      end

      it { expect(admin_user.has_role?(:editor, program.instance)).to be(true) }
      it { expect(admin_user.ports.where(roles: { name: :editor }).count).to eq(2) }

      it { expect(admin_user.has_role?(:manager, program.instance)).to be(true) }
      it { expect(admin_user.ports.where(roles: { name: :manager }).count).to eq(2) }
    end
  end
end
