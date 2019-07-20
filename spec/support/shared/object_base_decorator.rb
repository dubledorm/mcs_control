require 'support/shared/application_decorator'

RSpec.shared_examples 'base_decorator' do
  it {expect{subject.decorate.database_names}.to_not raise_error}
  it {expect{subject.decorate.program_names}.to_not raise_error}
  it {expect{subject.decorate.port_names}.to_not raise_error}

  it_behaves_like 'application_decorator'
end