require 'rails_helper'
require 'support/devise_support'
require 'support/shared/request_shared_examples'


RSpec.shared_examples 'update editable_instance' do
  it 'should update record' do
      put(admin_instance_path({ id: editable_instance.id, instance: { description: '12344566' } }))
      editable_instance.reload
      expect(editable_instance.description).to eq('12344566')
  end
end

RSpec.shared_examples 'any authorised user for instance' do
  it_should_behave_like 'get response 403' do
    subject { post(admin_instances_path(params)) }
  end

  it_should_behave_like 'get response 404' do
    subject { put(admin_instance_path({ id: editable_instance.id, instance: { description: '12344566' } } )) }
  end

  it_should_behave_like 'get response 404' do
    subject { delete(admin_instance_path({ id: editable_instance.id } )) }
  end

  it_should_behave_like 'get response 403' do
    subject { delete(admin_instance_path({ id: user_editable_instance.id } )) }
  end
end

RSpec.shared_examples 'any authorised user for program' do
  it_should_behave_like 'get response 404' do
    subject { delete(admin_instance_program_path({ instance_id: editable_program.instance.id,
                                                   id: editable_program.id, confirm: true  } )) }
  end

  it_should_behave_like 'get response 403' do
    subject { delete(admin_instance_program_path({ instance_id: user_editable_program.instance.id,
                                                   id: user_editable_program.id, confirm: true  } )) }
  end
end

RSpec.describe 'Program', type: :request do
  include DeviseSupport
  let!(:instance) { FactoryGirl.create(:instance) }
  let!(:program) { FactoryGirl.build(:program, instance: instance) }
  let!(:editable_program) { FactoryGirl.create(:program) }
  let(:params) { { instance_id: program.instance.id, program: program.attributes } }

  context 'when not authorisation' do
    it_should_behave_like 'redirect to login page' do
      subject { post(admin_instance_programs_path(params)) }
    end

    it_should_behave_like 'redirect to login page' do
      subject { delete(admin_instance_program_path({ instance_id: editable_program.instance.id,
                                                     id: editable_program.id, confirm: true  } )) }
    end
  end

  context 'when user is admin' do
    before :each do
      sign_in_as_admin
    end

    it { expect{ delete(admin_instance_program_path({ instance_id: editable_program.instance.id,
                                                        id: editable_program.id,
                                                        confirm: true  } )) }.to change(Program, :count).by(-1) }
  end

  context 'when user is manager' do
    let!(:user_editable_program) { FactoryGirl.create(:program) }

    before :each do
      sign_in_as_manager
      @user.add_role :manager, user_editable_program.instance
    end

    it_should_behave_like 'any authorised user for program'
  end

  context 'when user is editor' do
    let!(:user_editable_program) { FactoryGirl.create(:program) }

    before :each do
      sign_in_as_editor
      @user.add_role :editor, user_editable_program.instance
    end

    it_should_behave_like 'any authorised user for program'
  end

end


RSpec.describe 'Instance', type: :request do
  include DeviseSupport
  let!(:instance) { FactoryGirl.build(:instance) }
  let!(:editable_instance) { FactoryGirl.create(:instance) }
  let(:params) { { need_database_create: false, instance: instance.attributes } }

  context 'when not authorisation' do
    it_should_behave_like 'redirect to login page' do
      subject { post(admin_instances_path(params)) }
    end

    it_should_behave_like 'redirect to login page' do
      subject { put(admin_instance_path({ id: editable_instance.id, instance: { description: '12344566' } } )) }
    end

    it_should_behave_like 'redirect to login page' do
      subject { delete(admin_instance_path({ id: editable_instance.id, confirm: true  } )) }
    end
  end

  context 'when user is admin' do
    before :each do
      sign_in_as_admin
    end

    it { expect{ post(admin_instances_path(params)) }.to change(Instance, :count).by(1) }

    it_should_behave_like 'update editable_instance'

    it { expect{ delete(admin_instance_path({ id: editable_instance.id, confirm: true } )) }.to change(Instance, :count).by(-1) }
  end

  context 'when user is manager' do
    let!(:user_editable_instance) { FactoryGirl.create(:instance) }

    before :each do
      sign_in_as_manager
      @user.add_role :manager, user_editable_instance
    end

    it_should_behave_like 'any authorised user for instance'

    it_should_behave_like 'get response 403' do
      subject { put(admin_instance_path({ id: user_editable_instance.id, instance: { description: '12344566' } } )) }
    end
  end

  context 'when user is editor' do
    let!(:user_editable_instance) { FactoryGirl.create(:instance) }

    before :each do
      sign_in_as_editor
      @user.add_role :editor, user_editable_instance
    end

    it_should_behave_like 'any authorised user for instance'

    it_should_behave_like 'update editable_instance' do
      let(:editable_instance) {user_editable_instance}
    end
  end
end