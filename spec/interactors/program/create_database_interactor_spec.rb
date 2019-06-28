require 'rails_helper'

describe Program do

  describe 'standard call' do
    let!(:instance) {FactoryGirl.create :instance, name: 'chicken' }
    let!(:program) {FactoryGirl.create :program, program_type: 'mc',
                                       instance: instance,
                                       identification_name: 'chicken-mc',
                                       database_name: 'chicken_mc'}
    

    it 'should not generate exception' do
      # noinspection SpellCheckingInspection
      expect{Program::CreateDatabaseInteractor.call(program: program)}.not_to raise_error
    end

    it 'should return fail' do  # Создание базы не работает с транзакциями, поэтому здесь тест лдолжен падать
      # для проверки создания базы используется rails_helper_without_transactions.rb
      # noinspection SpellCheckingInspection
      expect(Program::CreateDatabaseInteractor.call(program: program).failure?).to be(true)
    end

    it 'should return error code' do  # Создание базы не работает с транзакциями, поэтому здесь тест лдолжен падать
      # для проверки создания базы используется rails_helper_without_transactions.rb
      # noinspection SpellCheckingInspection
      result = Program::CreateDatabaseInteractor.call(program: program)
      puts 'Отладочная печать: '
      puts result.message
      expect(result.message).to_not eq('')
    end
  end
end
