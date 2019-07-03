require 'rails_helper_without_transactions'

describe Program do

  before :each do
    Program.all.delete_all
    Instance.all.delete_all

    begin
      ActiveRecord::Base.connection.execute("drop database archenergo12345_mc")
    rescue
    end
    begin
      ActiveRecord::Base.connection.execute("create user archenergo12345")
    rescue
    end
  end

  # describe 'CreateDatabaseInteractor' do
  #   let!(:instance) {FactoryGirl.create :instance, name: 'archenergo12345', db_user_name: 'archenergo12345' }
  #   let!(:program) {FactoryGirl.create :program, program_type: 'mc',
  #                                      instance: instance,
  #                                      identification_name: 'archenergo12345-mc',
  #                                      database_name: 'archenergo12345_mc'
  #   }
  #
  #   describe 'standard call' do
  #
  #     it 'should return true' do
  #       # noinspection SpellCheckingInspection
  #       expect(Program::CreateDatabaseInteractor.call(program: program).success?).to be(true)
  #     end
  #   end
  #
  #   describe 'call without instance.db_user_name' do
  #     before :each do
  #       instance.db_user_name = nil;
  #       instance.save
  #     end
  #
  #     it 'should return false' do
  #       # noinspection SpellCheckingInspection
  #       result = Program::CreateDatabaseInteractor.call(program: program)
  #       puts result.message
  #       expect(result.success?).to be(false)
  #     end
  #   end
  # end
end
