require 'rails_helper'

describe Instance do

  shared_examples 'database user name eq' do
    context 'empty database' do
      it { expect(Instance::CreateDatabaseUserService.new(instance).call).to eq(coming_database_user) }
    end

    context 'database has two databases' do
      it 'should increment name counter if same name already exists' do
        allow_any_instance_of(Instance::CreateDatabaseUserService).to receive(:get_database_users_list).
            and_return( [coming_database_user, "#{coming_database_user}_1"] )
        expect(Instance::CreateDatabaseUserService.new(instance).call).to eq("#{coming_database_user}_2")
      end
    end
  end

  shared_examples 'argument error' do
    it { expect{Instance::CreateDatabaseUserService.new(instance).call}.to raise_error ArgumentError}
    it 'test print' do
      begin
        Instance::CreateDatabaseUserService.new(instance).call
      rescue ArgumentError => e
        puts 'Отладочная печать:'
        puts e.message
      end
    end
  end


  describe 'database user name' do

    it_should_behave_like 'database user name eq' do
      let(:instance) { FactoryGirl.build :instance, name: 'chicken' }
      let(:coming_database_user) { 'chicken' }
    end

    it_should_behave_like 'database user name eq' do
      let(:instance) { FactoryGirl.build :instance, name: 'my-chicken' }
      let(:coming_database_user) { 'my_chicken' }
    end


    it_should_behave_like 'argument error' do
      let(:instance) { FactoryGirl.build :instance, name: '' }
    end

    it_should_behave_like 'argument error' do
      let(:instance) { FactoryGirl.build :instance, name: nil }
    end
  end
end
